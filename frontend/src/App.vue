<script setup>
import { ref } from 'vue'

const result = ref('')
const error = ref('')
const loading = ref(false)

async function testBackend() {
  loading.value = true
  error.value = ''
  result.value = ''
  try {
    const res = await fetch('/api/hello')
    if (!res.ok) throw new Error('HTTP ' + res.status)
    const data = await res.json()
    result.value = `${data.msg}(来源:${data.from})`
  } catch (e) {
    error.value = '请求失败:' + e.message
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <main class="wrap">
    <h1>🍊 OrangeRec</h1>
    <p class="sub">前后端打通测试</p>

    <button :disabled="loading" @click="testBackend">
      {{ loading ? '请求中…' : '测试后端连接' }}
    </button>

    <p v-if="result" class="ok">✅ {{ result }}</p>
    <p v-if="error" class="err">❌ {{ error }}</p>
  </main>
</template>

<style scoped>
.wrap {
  max-width: 480px;
  margin: 80px auto;
  text-align: center;
  font-family: system-ui, sans-serif;
}
h1 {
  font-size: 2.5rem;
  margin-bottom: 0;
}
.sub {
  color: #888;
  margin-top: 4px;
}
button {
  margin-top: 24px;
  padding: 12px 28px;
  font-size: 1rem;
  border: none;
  border-radius: 8px;
  background: #ff7a18;
  color: #fff;
  cursor: pointer;
}
button:disabled {
  opacity: 0.6;
  cursor: default;
}
.ok {
  color: #1a8a3a;
  margin-top: 24px;
  font-size: 1.1rem;
}
.err {
  color: #c0392b;
  margin-top: 24px;
}
</style>
