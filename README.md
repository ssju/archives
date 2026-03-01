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

### 使用Docker Compose启动

```bash
docker-compose up -d
```

### 前端开发

```bash
cd frontend
npm install
npm run dev
```

### 后端开发

```bash
cd backend
mvn spring-boot:run
```

## 功能特性

- 符合DA/T 13-2022档号编制规则
- 符合DA/T 18-2022档案著录规则
- OCR智能识别
- AI辅助档案管理
- 知识图谱
- 多端支持(PC + 移动端)
