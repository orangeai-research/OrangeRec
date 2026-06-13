from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="OrangeRec API")

# 开发期允许前端跨域(本地 Vite dev server)。
# 上线后会改成只允许你的域名,这里先放开方便联调。
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/health")
def health():
    """健康检查:部署后用它确认后端活着。"""
    return {"status": "ok"}


@app.get("/api/hello")
def hello():
    """最小演示接口:前端按钮调它,验证前后端打通。"""
    return {"msg": "你好,这是 OrangeRec 后端 FastAPI 🍊", "from": "FastAPI"}
