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

-- 档案文件表 (符合DA/T 18-2022标准)
CREATE TABLE archive_file (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '档案ID',
    archive_code VARCHAR(100) NOT NULL UNIQUE COMMENT '档号(DA/T 13-2022)',
    title VARCHAR(500) NOT NULL COMMENT '题名',
    category VARCHAR(50) COMMENT '档案类别',
    security_level VARCHAR(20) DEFAULT 'public' COMMENT '密级:public,internal,confidential,secret',
    retention_period VARCHAR(20) COMMENT '保管期限:permanent,long_term,short_term',

    -- DA/T 18-2022 必填字段
    archive_date DATE COMMENT '文件形成时间',
    author VARCHAR(200) COMMENT '责任者',
    page_count INT COMMENT '页数',
    file_format VARCHAR(50) COMMENT '文件格式',

    -- 扩展字段
    keywords VARCHAR(500) COMMENT '关键词',
    abstract TEXT COMMENT '摘要',
    remarks TEXT COMMENT '备注',

    -- 存储信息
    storage_location VARCHAR(200) COMMENT '存储位置',
    file_path VARCHAR(500) COMMENT '文件路径',
    file_size BIGINT COMMENT '文件大小(字节)',

    -- OCR信息
    ocr_status VARCHAR(20) DEFAULT 'pending' COMMENT 'OCR状态:pending,processing,completed,failed',
    ocr_content LONGTEXT COMMENT 'OCR识别内容',
    ocr_confidence DECIMAL(5,2) COMMENT 'OCR置信度',

    -- 状态信息
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态:draft,reviewing,approved,archived',
    version INT DEFAULT 1 COMMENT '版本号',

    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    create_by BIGINT COMMENT '创建人',
    update_by BIGINT COMMENT '更新人',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',

    INDEX idx_archive_code (archive_code),
    INDEX idx_category (category),
    INDEX idx_status (status),
    INDEX idx_create_time (create_time),
    INDEX idx_deleted (deleted),
    FULLTEXT idx_title (title),
    FULLTEXT idx_keywords (keywords)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案文件表';

-- 档案导入日志表
CREATE TABLE archive_import_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    batch_no VARCHAR(50) NOT NULL COMMENT '批次号',
    file_name VARCHAR(200) COMMENT '文件名',
    total_count INT DEFAULT 0 COMMENT '总数',
    success_count INT DEFAULT 0 COMMENT '成功数',
    fail_count INT DEFAULT 0 COMMENT '失败数',
    dirty_data_count INT DEFAULT 0 COMMENT '脏数据数',
    status VARCHAR(20) DEFAULT 'processing' COMMENT '状态:processing,completed,failed',
    error_message TEXT COMMENT '错误信息',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_by BIGINT COMMENT '创建人',
    INDEX idx_batch_no (batch_no),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案导入日志表';

-- 档案借阅申请表
CREATE TABLE borrow_application (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '申请ID',
    application_no VARCHAR(50) NOT NULL UNIQUE COMMENT '申请编号',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    applicant_id BIGINT NOT NULL COMMENT '申请人ID',
    borrow_reason TEXT COMMENT '借阅原因',
    borrow_start_date DATE COMMENT '借阅开始日期',
    borrow_end_date DATE COMMENT '借阅结束日期',
    status VARCHAR(20) DEFAULT 'pending' COMMENT '状态:pending,approved,rejected,returned',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_application_no (application_no),
    INDEX idx_archive_id (archive_id),
    INDEX idx_applicant_id (applicant_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案借阅申请表';

-- 档案借阅审批流程表
CREATE TABLE borrow_approval_flow (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '流程ID',
    application_id BIGINT NOT NULL COMMENT '申请ID',
    approver_id BIGINT NOT NULL COMMENT '审批人ID',
    approval_level INT COMMENT '审批级别:1,2,3',
    approval_result VARCHAR(20) COMMENT '审批结果:approved,rejected',
    approval_comment TEXT COMMENT '审批意见',
    approval_time DATETIME COMMENT '审批时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_application_id (application_id),
    INDEX idx_approver_id (approver_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案借阅审批流程表';

-- 知识图谱实体表
CREATE TABLE knowledge_graph_entity (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '实体ID',
    entity_name VARCHAR(200) NOT NULL COMMENT '实体名称',
    entity_type VARCHAR(50) COMMENT '实体类型:person,organization,location,event',
    properties JSON COMMENT '实体属性',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_entity_name (entity_name),
    INDEX idx_entity_type (entity_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识图谱实体表';

-- 知识图谱关系表
CREATE TABLE knowledge_graph_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关系ID',
    source_entity_id BIGINT NOT NULL COMMENT '源实体ID',
    target_entity_id BIGINT NOT NULL COMMENT '目标实体ID',
    relation_type VARCHAR(50) COMMENT '关系类型',
    properties JSON COMMENT '关系属性',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_source_entity (source_entity_id),
    INDEX idx_target_entity (target_entity_id),
    INDEX idx_relation_type (relation_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识图谱关系表';

-- 系统标签库表
CREATE TABLE sys_tag_library (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签库ID',
    library_name VARCHAR(100) NOT NULL COMMENT '标签库名称',
    library_type VARCHAR(50) COMMENT '标签库类型',
    description VARCHAR(500) COMMENT '描述',
    is_exclusive TINYINT DEFAULT 0 COMMENT '是否独占:0否,1是',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',
    INDEX idx_library_name (library_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统标签库表';

-- 系统标签表
CREATE TABLE sys_tag (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '标签ID',
    library_id BIGINT NOT NULL COMMENT '标签库ID',
    tag_name VARCHAR(100) NOT NULL COMMENT '标签名称',
    tag_color VARCHAR(20) COMMENT '标签颜色',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',
    INDEX idx_library_id (library_id),
    INDEX idx_tag_name (tag_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统标签表';

-- 档案标签关联表
CREATE TABLE archive_tag (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    tag_id BIGINT NOT NULL COMMENT '标签ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_archive_tag (archive_id, tag_id),
    INDEX idx_archive_id (archive_id),
    INDEX idx_tag_id (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案标签关联表';

-- 档号编制规则表
CREATE TABLE sys_archive_code_rule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '规则ID',
    rule_name VARCHAR(100) NOT NULL COMMENT '规则名称',
    rule_template VARCHAR(500) NOT NULL COMMENT '规则模板',
    category VARCHAR(50) COMMENT '适用类别',
    description TEXT COMMENT '规则说明',
    is_default TINYINT DEFAULT 0 COMMENT '是否默认:0否,1是',
    status TINYINT DEFAULT 1 COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    deleted TINYINT DEFAULT 0 COMMENT '删除标记',
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档号编制规则表';

