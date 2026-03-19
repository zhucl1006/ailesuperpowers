# 代码仓分析详单（CODEBASE-ANALYSIS）

**项目名称：** {PROJECT_NAME}
**文档版本：** v1.0
**最后更新：** {UPDATE_DATE}
**分析人：** {OWNER}

---

## 0. 文档说明

### 0.1 目标

{DOCUMENT_GOAL}

### 0.2 信息来源与可信度

| 类型 | 来源 | 可信度 | 说明 |
|------|------|--------|------|
{SOURCE_TABLE}

### 0.3 分析范围与限制

{ANALYSIS_SCOPE_AND_LIMITS}

---

## 1. 代码仓结构总览

### 1.1 目录树摘要

```text
{DIRECTORY_TREE_SUMMARY}
```

### 1.2 目录职责映射

| 目录/文件 | 类型 | 职责 | 备注 |
|-----------|------|------|------|
{DIRECTORY_RESPONSIBILITY_TABLE}

---

## 2. 运行时入口与启动链路

### 2.1 应用入口

{APPLICATION_ENTRYPOINTS}

### 2.2 构建与脚本入口

{BUILD_AND_SCRIPT_ENTRYPOINTS}

### 2.3 测试入口

{TEST_ENTRYPOINTS}

### 2.4 启动链路 / 初始化顺序

{BOOTSTRAP_FLOW}

---

## 3. 模块地图

### 3.1 核心模块清单

| 模块 | 目录/文件 | 核心职责 | 上游 | 下游 | 状态 |
|------|-----------|----------|------|------|------|
{MODULE_MAP_TABLE}

### 3.2 模块依赖图

```mermaid
{MODULE_DEPENDENCY_DIAGRAM}
```

### 3.3 高复杂度 / 高耦合区域

{HIGH_COMPLEXITY_AREAS}

---

## 4. 外部契约盘点

### 4.1 API / RPC / CLI / Job / Webhook 一览

| 类型 | 名称/路径 | 实现入口 | 输入 | 输出 | 认证/触发方式 |
|------|-----------|----------|------|------|---------------|
{EXTERNAL_CONTRACTS_TABLE}

### 4.2 关键业务流程

{KEY_BUSINESS_FLOWS}

---

## 5. 数据资产盘点

### 5.1 核心实体 / Schema

| 实体 | 定义位置 | 关键字段 | 关联关系 | 备注 |
|------|----------|----------|----------|------|
{DATA_ENTITY_TABLE}

### 5.2 迁移 / 演进记录

{MIGRATION_SUMMARY}

### 5.3 状态机 / 生命周期

{STATE_LIFECYCLE_NOTES}

---

## 6. 配置与环境

### 6.1 环境变量矩阵

| 变量 | 使用位置 | 默认值来源 | 是否必填 | 风险 |
|------|----------|------------|----------|------|
{ENVIRONMENT_VARIABLES_TABLE}

### 6.2 配置文件清单

| 文件 | 作用 | 关键配置 | 备注 |
|------|------|----------|------|
{CONFIG_FILES_TABLE}

### 6.3 部署与运行依赖

{DEPLOYMENT_AND_RUNTIME_DEPENDENCIES}

---

## 7. 质量信号

### 7.1 测试现状

| 类型 | 覆盖范围 | 入口/命令 | 现状 |
|------|----------|-----------|------|
{TEST_STATUS_TABLE}

### 7.2 工程检查

{ENGINEERING_CHECKS}

### 7.3 TODO / FIXME / Deprecated

{TODO_FIXME_AND_DEPRECATION}

---

## 8. 技术债与风险

| 类型 | 描述 | 证据 | 影响 | 建议 |
|------|------|------|------|------|
{TECH_DEBT_AND_RISK_TABLE}

---

## 9. 待确认事项

{OPEN_QUESTIONS}

---

## 10. 后续建议

{FOLLOW_UP_RECOMMENDATIONS}

