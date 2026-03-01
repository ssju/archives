USE archive_db;

-- 插入默认管理员用户 (密码: admin123)
INSERT INTO sys_user (username, password, real_name, email, phone, department, position, status, login_type)
VALUES ('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'admin@archive.com', '13800138000', '信息技术部', '系统管理员', 1, 'password');

-- 插入默认角色
INSERT INTO sys_role (role_name, role_code, description, status)
VALUES
('超级管理员', 'ROLE_ADMIN', '拥有系统所有权限', 1),
('档案管理员', 'ROLE_ARCHIVE_ADMIN', '负责档案管理和审核', 1),
('普通用户', 'ROLE_USER', '普通用户权限', 1);

-- 关联管理员用户和超级管理员角色
INSERT INTO sys_user_role (user_id, role_id)
VALUES (1, 1);

-- 插入默认权限
INSERT INTO sys_permission (permission_name, permission_code, permission_type, parent_id, path, icon, sort_order, status)
VALUES
('工作台', 'dashboard', 'menu', 0, '/dashboard', 'HomeFilled', 1, 1),
('档案管理', 'archive', 'menu', 0, '/archive', 'Folder', 2, 1),
('档案列表', 'archive:list', 'menu', 2, '/archive/list', '', 1, 1),
('档案新增', 'archive:create', 'button', 2, '', '', 2, 1),
('档案编辑', 'archive:edit', 'button', 2, '', '', 3, 1),
('档案删除', 'archive:delete', 'button', 2, '', '', 4, 1),
('OCR识别', 'archive:ocr', 'menu', 2, '/archive/ocr', '', 5, 1),
('智能检索', 'search', 'menu', 0, '/search', 'Search', 3, 1),
('统计分析', 'statistics', 'menu', 0, '/statistics', 'DataAnalysis', 4, 1),
('系统管理', 'system', 'menu', 0, '/system', 'Setting', 5, 1),
('用户管理', 'system:user', 'menu', 10, '/system/user', '', 1, 1),
('角色管理', 'system:role', 'menu', 10, '/system/role', '', 2, 1),
('系统配置', 'system:config', 'menu', 10, '/system/config', '', 3, 1);

-- 关联超级管理员角色和所有权限
INSERT INTO sys_role_permission (role_id, permission_id)
SELECT 1, id FROM sys_permission;

-- 插入默认标签库
INSERT INTO sys_tag_library (library_name, library_type, description, is_exclusive, status)
VALUES
('档案类别', 'category', '档案分类标签库', 1, 1),
('密级', 'security', '档案密级标签库', 1, 1),
('保管期限', 'retention', '档案保管期限标签库', 1, 1);

-- 插入默认标签
INSERT INTO sys_tag (library_id, tag_name, tag_color, sort_order, status)
VALUES
-- 档案类别
(1, '文书档案', '#409EFF', 1, 1),
(1, '科技档案', '#67C23A', 2, 1),
(1, '会计档案', '#E6A23C', 3, 1),
(1, '人事档案', '#F56C6C', 4, 1),
-- 密级
(2, '公开', '#909399', 1, 1),
(2, '内部', '#409EFF', 2, 1),
(2, '秘密', '#E6A23C', 3, 1),
(2, '机密', '#F56C6C', 4, 1),
-- 保管期限
(3, '永久', '#67C23A', 1, 1),
(3, '长期', '#409EFF', 2, 1),
(3, '短期', '#909399', 3, 1);

-- 插入默认档号编制规则 (符合DA/T 13-2022)
INSERT INTO sys_archive_code_rule (rule_name, rule_template, category, description, is_default, status)
VALUES
('文书档案档号规则', '{org_code}-{year}-{category}-{serial}', '文书档案', '全宗号-年度-类别号-顺序号', 1, 1),
('科技档案档号规则', '{org_code}-{project_code}-{category}-{serial}', '科技档案', '全宗号-项目号-类别号-顺序号', 0, 1),
('会计档案档号规则', '{org_code}-{year}-{category}-{month}-{serial}', '会计档案', '全宗号-年度-类别号-月份-顺序号', 0, 1);

