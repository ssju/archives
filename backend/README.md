# 后端启动说明

## 前提条件
需要安装以下工具:
- JDK 1.8
- Maven 3.6+

## 启动步骤

### 方式一: 使用Maven命令
```bash
cd backend
mvn spring-boot:run
```

### 方式二: 使用IDE
1. 使用IDEA或Eclipse打开backend目录
2. 等待Maven依赖下载完成
3. 运行 `com.archive.ArchiveApplication` 主类

## 验证
后端启动成功后,访问: http://localhost:8080/api

## 注意事项
- 确保Docker容器已启动 (MySQL, Redis, Elasticsearch, RabbitMQ)
- 首次启动会自动创建数据库表并初始化数据
- 默认管理员账号: admin / admin123
