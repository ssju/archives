# 智能档案管理系统实施计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 构建一个符合DA/T标准的前后端分离智能档案管理系统，支持OCR识别、AI辅助和知识图谱功能

**Architecture:** 前端使用Vue3+Element Plus构建响应式界面，后端使用SpringBoot 2.7.x提供RESTful API，数据层使用MySQL+Redis+Elasticsearch+RabbitMQ，通过Docker容器化部署

**Tech Stack:** Vue3, Element Plus, Vant, SpringBoot 2.7.x, JDK 1.8, MySQL 8.0, Redis 6.2, Elasticsearch 7.17, RabbitMQ 3.11, Docker

---

## Phase 1: 项目基础架构搭建

### Task 1: 创建项目目录结构

**Files:**
- Create: `README.md`
- Create: `docker-compose.yml`
- Create: `.gitignore`
- Create: `docs/README.md`

**Step 1: 创建根目录README**

创建项目根目录说明文档：

```bash
touch README.md
```

**Step 2: 编写README内容**

编辑 `README.md`:

```markdown
# 智能档案管理系统

符合DA/T 13-2022和DA/T 18-2022标准的智能档案管理系统

## 技术栈

- 前端: Vue3 + Element Plus + Vant
- 后端: SpringBoot 2.7.x + JDK 1.8
- 数据库: MySQL 8.0 + Redis 6.2 + Elasticsearch 7.17
- 消息队列: RabbitMQ 3.11
- 部署: Docker + Docker Compose

## 项目结构

```
archives/
├── frontend/          # Vue3前端项目
├── backend/           # SpringBoot后端项目
├── docker/            # Docker配置文件
├── docs/              # 文档
└── docker-compose.yml # 容器编排配置
```

## 快速开始

详见各子项目README
```

**Step 3: 创建.gitignore**

创建 `.gitignore`:

```gitignore
# IDE
.idea/
.vscode/
*.iml

# Node
node_modules/
dist/
.DS_Store

# Java
target/
*.class
*.jar
*.war

# Logs
logs/
*.log

# Environment
.env
.env.local

# Docker
docker/data/
```

**Step 4: 创建docker-compose.yml骨架**

创建 `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: archive-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: archive_db
    ports:
      - "3306:3306"
    volumes:
      - ./docker/mysql/data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
    networks:
      - archive-network

  redis:
    image: redis:6.2-alpine
    container_name: archive-redis
    ports:
      - "6379:6379"
    networks:
      - archive-network

  elasticsearch:
    image: elasticsearch:7.17.9
    container_name: archive-es
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "9200:9200"
    volumes:
      - ./docker/elasticsearch/data:/usr/share/elasticsearch/data
    networks:
      - archive-network

  rabbitmq:
    image: rabbitmq:3.11-management-alpine
    container_name: archive-rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: admin123
    networks:
      - archive-network

networks:
  archive-network:
    driver: bridge
```

**Step 5: 提交基础结构**

```bash
git add README.md .gitignore docker-compose.yml
git commit -m "chore: initialize project structure"
```

### Task 2: 后端SpringBoot项目初始化

**Files:**
- Create: `backend/pom.xml`
- Create: `backend/src/main/java/com/archive/ArchiveApplication.java`
- Create: `backend/src/main/resources/application.yml`
- Create: `backend/src/main/resources/application-dev.yml`

**Step 1: 创建backend目录**

```bash
mkdir -p backend/src/main/java/com/archive
mkdir -p backend/src/main/resources
mkdir -p backend/src/test/java/com/archive
```

**Step 2: 创建pom.xml**

创建 `backend/pom.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
        <relativePath/>
    </parent>

    <groupId>com.archive</groupId>
    <artifactId>archive-system</artifactId>
    <version>1.0.0</version>
    <name>Archive Management System</name>

    <properties>
        <java.version>1.8</java.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <mybatis-plus.version>3.5.3.1</mybatis-plus.version>
        <hutool.version>5.8.16</hutool.version>
        <jwt.version>0.11.5</jwt.version>
    </properties>

    <dependencies>
        <!-- Spring Boot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- Spring Security -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>

        <!-- MySQL Driver -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.33</version>
        </dependency>

        <!-- MyBatis Plus -->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>${mybatis-plus.version}</version>
        </dependency>

        <!-- Redis -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-redis</artifactId>
        </dependency>

        <!-- Elasticsearch -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
        </dependency>

        <!-- RabbitMQ -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-amqp</artifactId>
        </dependency>

        <!-- JWT -->
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>${jwt.version}</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>${jwt.version}</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-jackson</artifactId>
            <version>${jwt.version}</version>
            <scope>runtime</scope>
        </dependency>

        <!-- Hutool -->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
            <version>${hutool.version}</version>
        </dependency>

        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>

        <!-- Swagger -->
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-boot-starter</artifactId>
            <version>3.0.0</version>
        </dependency>

        <!-- Validation -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>

        <!-- Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

**Step 3: 创建启动类**

创建 `backend/src/main/java/com/archive/ArchiveApplication.java`:

```java
package com.archive;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ArchiveApplication {
    public static void main(String[] args) {
        SpringApplication.run(ArchiveApplication.class, args);
    }
}
```

**Step 4: 创建application.yml**

创建 `backend/src/main/resources/application.yml`:

```yaml
spring:
  profiles:
    active: dev
  application:
    name: archive-system

server:
  port: 8080
  servlet:
    context-path: /api
```

**Step 5: 创建application-dev.yml**

创建 `backend/src/main/resources/application-dev.yml`:

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/archive_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: root123

  redis:
    host: localhost
    port: 6379
    database: 0
    timeout: 3000ms

  elasticsearch:
    uris: http://localhost:9200

  rabbitmq:
    host: localhost
    port: 5672
    username: admin
    password: admin123

mybatis-plus:
  mapper-locations: classpath*:/mapper/**/*.xml
  type-aliases-package: com.archive.entity
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

logging:
  level:
    com.archive: debug
```

**Step 6: 提交后端初始化**

```bash
git add backend/
git commit -m "feat: initialize SpringBoot backend project"
```

### Task 3: 前端Vue3项目初始化

**Files:**
- Create: `frontend/package.json`
- Create: `frontend/vite.config.js`
- Create: `frontend/index.html`
- Create: `frontend/src/main.js`
- Create: `frontend/src/App.vue`

**Step 1: 创建frontend目录结构**

```bash
mkdir -p frontend/src/{views,components,router,store,api,utils,assets}
mkdir -p frontend/public
```

**Step 2: 创建package.json**

创建 `frontend/package.json`:

```json
{
  "name": "archive-frontend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.2.5",
    "pinia": "^2.1.7",
    "element-plus": "^2.5.0",
    "vant": "^4.8.0",
    "axios": "^1.6.0",
    "echarts": "^5.4.3",
    "pdfjs-dist": "^3.11.0",
    "viewerjs": "^1.11.6"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0",
    "sass": "^1.69.0"
  }
}
```

**Step 3: 创建vite.config.js**

创建 `frontend/vite.config.js`:

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

**Step 4: 创建index.html**

创建 `frontend/index.html`:

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>智能档案管理系统</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
```

**Step 5: 创建main.js**

创建 `frontend/src/main.js`:

```javascript
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import router from './router'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)
app.use(ElementPlus)

app.mount('#app')
```

**Step 6: 创建App.vue**

创建 `frontend/src/App.vue`:

```vue
<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script setup>
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  width: 100%;
  height: 100vh;
}
</style>
```

**Step 7: 创建路由配置**

创建 `frontend/src/router/index.js`:

```javascript
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

**Step 8: 提交前端初始化**

```bash
git add frontend/
git commit -m "feat: initialize Vue3 frontend project"
```

## Phase 2: 数据库设计与实现

### Task 4: 创建数据库初始化脚本

**Files:**
- Create: `docker/mysql/init/01-schema.sql`
- Create: `docker/mysql/init/02-data.sql`

**Step 1: 创建目录**

```bash
mkdir -p docker/mysql/init
```

**Step 2: 创建schema.sql (用户表)**

创建 `docker/mysql/init/01-schema.sql`:

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS archive_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE archive_db;

-- 用户表
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密)',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    department VARCHAR(100) COMMENT '部门',
    position VARCHAR(50) COMMENT '职位',
    status TINYINT DEFAULT 1 COMMENT '状态:0禁用,1启用',
    login_type VARCHAR(20) DEFAULT 'password' COMMENT '登录方式:password,wechat,dingtalk,usbkey,fingerprint',
    last_login_time DATETIME COMMENT '最后登录时间',
    last_login_ip VARCHAR(50) COMMENT '最后登录IP',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    create_by BIGINT COMMENT '创建人',
    update_by BIGINT COMMENT '更新人',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记:0未删除,1已删除',
    INDEX idx_username (username),
    INDEX idx_status (status),
    INDEX idx_deleted (deleted)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 角色表
CREATE TABLE sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(200) COMMENT '角色描述',
    status TINYINT DEFAULT 1 COMMENT '状态:0禁用,1启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',
    INDEX idx_role_code (role_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 用户角色关联表
CREATE TABLE sys_user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_user_role (user_id, role_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 权限表
CREATE TABLE sys_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '权限ID',
    permission_name VARCHAR(50) NOT NULL COMMENT '权限名称',
    permission_code VARCHAR(100) NOT NULL UNIQUE COMMENT '权限编码',
    permission_type VARCHAR(20) COMMENT '权限类型:menu,button,api',
    parent_id BIGINT DEFAULT 0 COMMENT '父权限ID',
    path VARCHAR(200) COMMENT '路由路径',
    component VARCHAR(200) COMMENT '组件路径',
    icon VARCHAR(50) COMMENT '图标',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',
    INDEX idx_parent_id (parent_id),
    INDEX idx_permission_code (permission_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 角色权限关联表
CREATE TABLE sys_role_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    permission_id BIGINT NOT NULL COMMENT '权限ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_role_permission (role_id, permission_id),
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';
```

**Step 3: 继续创建档案相关表**

继续编辑 `docker/mysql/init/01-schema.sql`，添加档案表:

