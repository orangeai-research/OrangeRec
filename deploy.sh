#!/usr/bin/env bash
# OrangeRec 一键部署脚本(在 Droplet 上以 root 运行)
# 用法:bash deploy.sh [域名]   不传域名则用 IP 访问
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN="${1:-_}"
export DEBIAN_FRONTEND=noninteractive

echo ">>> [1/6] 安装系统依赖(nginx / python venv / git)..."
apt-get update -qq
apt-get install -y -qq python3-venv python3-pip nginx git curl ca-certificates

echo ">>> [2/6] 安装 Node.js 22..."
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null
  apt-get install -y -qq nodejs
fi
echo "    node $(node -v)"

echo ">>> [3/6] 后端:创建 venv 并安装依赖..."
cd "$REPO_DIR/backend"
python3 -m venv venv
./venv/bin/pip install -q --upgrade pip
./venv/bin/pip install -q -r requirements.txt

echo ">>> [4/6] 配置后端 systemd 服务(uvicorn @127.0.0.1:8000)..."
cat > /etc/systemd/system/orangerec-api.service <<EOF
[Unit]
Description=OrangeRec FastAPI backend
After=network.target

[Service]
WorkingDirectory=$REPO_DIR/backend
ExecStart=$REPO_DIR/backend/venv/bin/uvicorn main:app --host 127.0.0.1 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable -q orangerec-api
systemctl restart orangerec-api

echo ">>> [5/6] 构建前端(npm install + build)..."
cd "$REPO_DIR/frontend"
npm install --no-fund --no-audit --silent
npm run build

echo ">>> [6/6] 配置 Nginx(/ 给前端,/api 反代后端)..."
cat > /etc/nginx/sites-available/orangerec <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $REPO_DIR/frontend/dist;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF
ln -sf /etc/nginx/sites-available/orangerec /etc/nginx/sites-enabled/orangerec
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx

IP="$(curl -s --max-time 5 ifconfig.me || hostname -I | awk '{print $1}')"
echo ""
echo "========================================================"
echo " ✅ 部署完成!浏览器访问:  http://$IP/"
echo " 后端健康检查:            http://$IP/api/health"
echo " 查看后端日志:  journalctl -u orangerec-api -f"
echo "========================================================"
