import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('@/views/Dashboard.vue'),
    meta: { title: '工作台', requiresAuth: true }
  },
  {
    path: '/archive',
    name: 'Archive',
    component: () => import('@/views/archive/Index.vue'),
    meta: { title: '档案管理', requiresAuth: true },
    children: [
      {
        path: 'list',
        name: 'ArchiveList',
        component: () => import('@/views/archive/List.vue'),
        meta: { title: '档案列表' }
      },
      {
        path: 'edit/:id?',
        name: 'ArchiveEdit',
        component: () => import('@/views/archive/Edit.vue'),
        meta: { title: '档案编辑' }
      },
      {
        path: 'ocr',
        name: 'ArchiveOCR',
        component: () => import('@/views/archive/OCR.vue'),
        meta: { title: 'OCR识别' }
      }
    ]
  },
  {
    path: '/search',
    name: 'Search',
    component: () => import('@/views/Search.vue'),
    meta: { title: '智能检索', requiresAuth: true }
  },
  {
    path: '/statistics',
    name: 'Statistics',
    component: () => import('@/views/Statistics.vue'),
    meta: { title: '统计分析', requiresAuth: true }
  },
  {
    path: '/system',
    name: 'System',
    component: () => import('@/views/system/Index.vue'),
    meta: { title: '系统管理', requiresAuth: true },
    children: [
      {
        path: 'user',
        name: 'SystemUser',
        component: () => import('@/views/system/User.vue'),
        meta: { title: '用户管理' }
      },
      {
        path: 'role',
        name: 'SystemRole',
        component: () => import('@/views/system/Role.vue'),
        meta: { title: '角色管理' }
      },
      {
        path: 'config',
        name: 'SystemConfig',
        component: () => import('@/views/system/Config.vue'),
        meta: { title: '系统配置' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')

  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
