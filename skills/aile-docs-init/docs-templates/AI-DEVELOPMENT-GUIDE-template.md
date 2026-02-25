# AI 开发指南

**项目名称：** {PROJECT_NAME}
**最后更新：** {UPDATE_DATE}

---

## 概述

本文档是 {PROJECT_NAME} 项目的 AI 开发指南，规定了 AI 辅助开发时必须遵循的流程、规范和最佳实践。

**目标读者：** Claude Code、GitHub Copilot 等 AI 开发工具

---

## 开发流程

### TDD（测试驱动开发）流程

**强制要求：** 所有代码开发必须遵循 TDD 流程。

```
1. 编写测试（Red）
   ↓
2. 运行测试（失败）
   ↓
3. 编写实现代码（Green）
   ↓
4. 运行测试（通过）
   ↓
5. 重构优化（Refactor）
   ↓
6. 运行测试（确保通过）
```

### 开发步骤详解

#### Step 1: 理解需求

1. 阅读 [PRD.md](../specs/PRD.md) 了解产品需求
2. 阅读 [SAD.md](../specs/SAD.md) 了解架构设计
3. 阅读相关模块文档了解实现细节

#### Step 2: 编写测试

{TEST_WRITING_GUIDELINES}

#### Step 3: 实现功能

{IMPLEMENTATION_GUIDELINES}

#### Step 4: 代码审查

{CODE_REVIEW_CHECKLIST}

---

## 代码规范

### {LANGUAGE} 代码规范

{LANGUAGE_STYLE_GUIDE}

### 项目特定规范

{PROJECT_SPECIFIC_CONVENTIONS}

---

## 模块开发规范

### 前端开发规范

{FRONTEND_CONVENTIONS}

### 后端开发规范

{BACKEND_CONVENTIONS}

### 数据库操作规范

{DATABASE_CONVENTIONS}

---

## 测试规范

### 单元测试

{UNIT_TEST_GUIDELINES}

### 集成测试

{INTEGRATION_TEST_GUIDELINES}

### 测试覆盖率要求

{COVERAGE_REQUIREMENTS}

---

## Git 工作流

### 分支策略

{BRANCH_STRATEGY}

### Commit 规范

{COMMIT_CONVENTIONS}

### Pull Request 规范

{PR_CONVENTIONS}

---

## CI/CD

### 持续集成

{CI_PIPELINE}

### 持续部署

{CD_PIPELINE}

---

## 错误处理

### 异常处理规范

{ERROR_HANDLING_CONVENTIONS}

### 日志规范

{LOGGING_CONVENTIONS}

---

## 性能优化

### 性能标准

{PERFORMANCE_STANDARDS}

### 优化策略

{OPTIMIZATION_STRATEGIES}

---

## 安全规范

### 安全编码实践

{SECURITY_CODING_PRACTICES}

### 常见安全问题清单

{SECURITY_CHECKLIST}

---

## 文档规范

### 代码注释

{COMMENT_CONVENTIONS}

### API 文档

{API_DOCUMENTATION_STANDARDS}

### 技术文档更新

{DOC_UPDATE_GUIDELINES}

---

## 常见反模式（Anti-patterns）

**禁止以下做法：**

{ANTI_PATTERNS}

---

## 最佳实践

{BEST_PRACTICES}

---

## 工具和资源

### 开发工具

{DEVELOPMENT_TOOLS}

### 推荐资源

{RECOMMENDED_RESOURCES}

---

## Changelog

| 日期 | 变更内容 | 变更人 |
|------|----------|--------|
| {CREATE_DATE} | 创建文档 | {OWNER} |
