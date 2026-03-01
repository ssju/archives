import { defineStore } from 'pinia'
import { login, getUserInfo, logout } from '@/api/auth'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    userInfo: null
  }),

  getters: {
    isLoggedIn: (state) => !!state.token
  },

  actions: {
    // 登录
    async login(loginForm) {
      try {
        const res = await login(loginForm)
        this.token = res.data.token
        localStorage.setItem('token', res.data.token)
        return res
      } catch (error) {
        throw error
      }
    },

    // 获取用户信息
    async getUserInfo() {
      try {
        const res = await getUserInfo()
        this.userInfo = res.data
        return res
      } catch (error) {
        throw error
      }
    },

    // 登出
    async logout() {
      try {
        await logout()
        this.token = ''
        this.userInfo = null
        localStorage.removeItem('token')
      } catch (error) {
        throw error
      }
    }
  }
})
