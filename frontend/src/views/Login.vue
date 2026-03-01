<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1>智能档案管理系统</h1>
        <p>符合DA/T 13-2022和DA/T 18-2022标准</p>
      </div>

      <el-tabs v-model="loginType" class="login-tabs">
        <el-tab-pane label="密码登录" name="password">
          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            class="login-form"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                prefix-icon="User"
                size="large"
              />
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                prefix-icon="Lock"
                size="large"
                show-password
                @keyup.enter="handleLogin"
              />
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                size="large"
                :loading="loading"
                class="login-button"
                @click="handleLogin"
              >
                登录
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <el-tab-pane label="微信登录" name="wechat">
          <div class="qrcode-login">
            <div class="qrcode-placeholder">
              <el-icon :size="80"><QrCode /></el-icon>
              <p>请使用微信扫码登录</p>
            </div>
          </div>
        </el-tab-pane>

        <el-tab-pane label="钉钉登录" name="dingtalk">
          <div class="qrcode-login">
            <div class="qrcode-placeholder">
              <el-icon :size="80"><QrCode /></el-icon>
              <p>请使用钉钉扫码登录</p>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/user'

const router = useRouter()
const userStore = useUserStore()

const loginType = ref('password')
const loading = ref(false)
const loginFormRef = ref(null)

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6位', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  if (!loginFormRef.value) return

  await loginFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        console.log('开始登录...', loginForm)
        const result = await userStore.login(loginForm)
        console.log('登录结果:', result)
        ElMessage.success('登录成功')
        console.log('准备跳转到 /dashboard')
        await router.push('/dashboard')
        console.log('跳转命令已执行')
      } catch (error) {
        console.error('登录错误:', error)
        ElMessage.error(error.message || '登录失败')
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style scoped lang="scss">
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-box {
  width: 450px;
  padding: 40px;
  background: white;
  border-radius: 10px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;

  h1 {
    font-size: 28px;
    color: #333;
    margin-bottom: 10px;
  }

  p {
    font-size: 14px;
    color: #999;
  }
}

.login-tabs {
  :deep(.el-tabs__nav-wrap::after) {
    display: none;
  }
}

.login-form {
  margin-top: 30px;
}

.login-button {
  width: 100%;
}

.qrcode-login {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 300px;
}

.qrcode-placeholder {
  text-align: center;
  color: #999;

  p {
    margin-top: 20px;
    font-size: 14px;
  }
}
</style>
