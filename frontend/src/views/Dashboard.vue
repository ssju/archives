<template>
  <div class="dashboard-container">
    <el-container>
      <el-aside width="200px">
        <div class="logo">
          <h2>档案系统</h2>
        </div>
        <el-menu
          :default-active="activeMenu"
          router
          class="sidebar-menu"
        >
          <el-menu-item index="/dashboard">
            <el-icon><HomeFilled /></el-icon>
            <span>工作台</span>
          </el-menu-item>
          <el-menu-item index="/archive/list">
            <el-icon><Folder /></el-icon>
            <span>档案管理</span>
          </el-menu-item>
          <el-menu-item index="/search">
            <el-icon><Search /></el-icon>
            <span>智能检索</span>
          </el-menu-item>
          <el-menu-item index="/statistics">
            <el-icon><DataAnalysis /></el-icon>
            <span>统计分析</span>
          </el-menu-item>
          <el-sub-menu index="/system">
            <template #title>
              <el-icon><Setting /></el-icon>
              <span>系统管理</span>
            </template>
            <el-menu-item index="/system/user">用户管理</el-menu-item>
            <el-menu-item index="/system/role">角色管理</el-menu-item>
            <el-menu-item index="/system/config">系统配置</el-menu-item>
          </el-sub-menu>
        </el-menu>
      </el-aside>

      <el-container>
        <el-header>
          <div class="header-content">
            <div class="header-left">
              <el-breadcrumb separator="/">
                <el-breadcrumb-item :to="{ path: '/dashboard' }">首页</el-breadcrumb-item>
                <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
              </el-breadcrumb>
            </div>
            <div class="header-right">
              <el-dropdown @command="handleCommand">
                <span class="user-info">
                  <el-icon><User /></el-icon>
                  <span>{{ userInfo?.realName || '管理员' }}</span>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                    <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </div>
          </div>
        </el-header>

        <el-main>
          <div class="main-content">
            <el-row :gutter="20">
              <el-col :span="6">
                <el-card class="stat-card">
                  <div class="stat-content">
                    <div class="stat-icon" style="background: #409eff;">
                      <el-icon :size="30"><Folder /></el-icon>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ stats.totalArchives }}</div>
                      <div class="stat-label">档案总数</div>
                    </div>
                  </div>
                </el-card>
              </el-col>
              <el-col :span="6">
                <el-card class="stat-card">
                  <div class="stat-content">
                    <div class="stat-icon" style="background: #67c23a;">
                      <el-icon :size="30"><DocumentAdd /></el-icon>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ stats.todayAdded }}</div>
                      <div class="stat-label">今日新增</div>
                    </div>
                  </div>
                </el-card>
              </el-col>
              <el-col :span="6">
                <el-card class="stat-card">
                  <div class="stat-content">
                    <div class="stat-icon" style="background: #e6a23c;">
                      <el-icon :size="30"><View /></el-icon>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ stats.todayViews }}</div>
                      <div class="stat-label">今日查阅</div>
                    </div>
                  </div>
                </el-card>
              </el-col>
              <el-col :span="6">
                <el-card class="stat-card">
                  <div class="stat-content">
                    <div class="stat-icon" style="background: #f56c6c;">
                      <el-icon :size="30"><Warning /></el-icon>
                    </div>
                    <div class="stat-info">
                      <div class="stat-value">{{ stats.pendingApprovals }}</div>
                      <div class="stat-label">待审批</div>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>

            <el-row :gutter="20" style="margin-top: 20px;">
              <el-col :span="12">
                <el-card>
                  <template #header>
                    <span>最近操作</span>
                  </template>
                  <el-empty v-if="recentActivities.length === 0" description="暂无数据" />
                  <el-timeline v-else>
                    <el-timeline-item
                      v-for="activity in recentActivities"
                      :key="activity.id"
                      :timestamp="activity.time"
                    >
                      {{ activity.content }}
                    </el-timeline-item>
                  </el-timeline>
                </el-card>
              </el-col>
              <el-col :span="12">
                <el-card>
                  <template #header>
                    <span>待办事项</span>
                  </template>
                  <el-empty v-if="todos.length === 0" description="暂无待办" />
                  <div v-else class="todo-list">
                    <div v-for="todo in todos" :key="todo.id" class="todo-item">
                      <el-checkbox v-model="todo.completed">
                        {{ todo.content }}
                      </el-checkbox>
                    </div>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/store/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)
const currentTitle = computed(() => route.meta.title || '工作台')
const userInfo = computed(() => userStore.userInfo)

const stats = ref({
  totalArchives: 0,
  todayAdded: 0,
  todayViews: 0,
  pendingApprovals: 0
})

const recentActivities = ref([])
const todos = ref([])

const handleCommand = async (command) => {
  if (command === 'logout') {
    try {
      await ElMessageBox.confirm('确定要退出登录吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      })
      await userStore.logout()
      ElMessage.success('已退出登录')
      router.push('/login')
    } catch (error) {
      // 用户取消
    }
  } else if (command === 'profile') {
    ElMessage.info('个人中心功能开发中')
  }
}

const loadDashboardData = async () => {
  // 模拟数据
  stats.value = {
    totalArchives: 1250,
    todayAdded: 15,
    todayViews: 89,
    pendingApprovals: 3
  }

  recentActivities.value = [
    { id: 1, content: '创建档案: 2024年度财务报表', time: '2026-03-01 14:30' },
    { id: 2, content: 'OCR识别完成: 合同文件001', time: '2026-03-01 13:15' },
    { id: 3, content: '审批通过: 档案借阅申请', time: '2026-03-01 11:20' }
  ]

  todos.value = [
    { id: 1, content: '审批档案借阅申请', completed: false },
    { id: 2, content: '完成本月档案统计报表', completed: false },
    { id: 3, content: '检查档案质量', completed: false }
  ]
}

onMounted(() => {
  loadDashboardData()
  if (!userInfo.value) {
    userStore.getUserInfo()
  }
})
</script>

<style scoped lang="scss">
.dashboard-container {
  width: 100%;
  height: 100vh;
}

.el-aside {
  background: #304156;
  color: #fff;
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #2b3a4a;

  h2 {
    font-size: 20px;
    color: #fff;
  }
}

.sidebar-menu {
  border: none;
  background: #304156;

  :deep(.el-menu-item),
  :deep(.el-sub-menu__title) {
    color: #bfcbd9;

    &:hover {
      background: #263445;
      color: #fff;
    }

    &.is-active {
      background: #409eff;
      color: #fff;
    }
  }
}

.el-header {
  background: #fff;
  border-bottom: 1px solid #e6e6e6;
  padding: 0 20px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;

  &:hover {
    color: #409eff;
  }
}

.el-main {
  background: #f0f2f5;
  padding: 20px;
}

.stat-card {
  :deep(.el-card__body) {
    padding: 20px;
  }
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 20px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #333;
}

.stat-label {
  font-size: 14px;
  color: #999;
  margin-top: 5px;
}

.todo-list {
  .todo-item {
    padding: 10px 0;
    border-bottom: 1px solid #f0f0f0;

    &:last-child {
      border-bottom: none;
    }
  }
}
</style>
