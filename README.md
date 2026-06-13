# OrangeRec 下一代生成式多模态推荐系统

前后端分离项目。详见 [dev.md](dev.md)。

## 技术栈

| 层 | 技术 |
|----|------|
| 前端 | Vue 3 + Vite |
| 后端 | FastAPI + Uvicorn |
| 算法层 | 预留(模型部署) |
| 部署 | DigitalOcean Droplet + .tech 域名 |

## 目录结构

```
OrangeRec/
├── backend/        FastAPI 后端
│   ├── main.py         接口入口
│   ├── requirements.txt
│   └── venv/           虚拟环境(已 gitignore)
└── frontend/       Vue 前端(Vite)
    ├── src/App.vue     首页(含前后端打通测试)
    └── vite.config.js  含 /api 开发代理
```

## 本地运行

需要开**两个终端**:

**1. 后端(端口 8000)**
```bash
cd backend
./venv/bin/uvicorn main:app --reload --port 8000
```

**2. 前端(端口 5173)**
```bash
cd frontend
npm run dev
```

然后浏览器打开 http://localhost:5173 ,点「测试后端连接」按钮即可验证打通。

> 前端调用 `/api/xxx`,开发期由 Vite 代理转发到后端;上线后由 Nginx 转发。前端代码无需改动。

## 接口

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/health` | 健康检查 |
| GET | `/api/hello` | 打通测试 |

FastAPI 自带交互式文档:启动后端后访问 http://localhost:8000/docs
