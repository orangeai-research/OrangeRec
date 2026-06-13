import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      // 开发期:前端发往 /api 的请求,转发到本地 FastAPI(127.0.0.1:8000)
      // 这样前端代码统一写 /api/xxx,本地走这个代理,线上走 Nginx,代码不用改
      '/api': 'http://127.0.0.1:8000',
    },
  },
})
