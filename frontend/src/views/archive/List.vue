<template>
  <div class="archive-list">
    <el-card>
      <template #header>
        <div class="header-actions">
          <span>档案列表</span>
          <el-button type="primary" @click="handleAdd">新增档案</el-button>
        </div>
      </template>
      <el-empty description="档案列表功能开发中" />
    </el-card>
  </div>
</template>

<script setup>
const handleAdd = () => {
  console.log('新增档案')
}
</script>

<style scoped>
.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>
