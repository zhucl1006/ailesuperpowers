# {PROJECT_NAME} - 技术文档中心

**最后更新：** {UPDATE_DATE}

---

## 项目概述

{PROJECT_DESCRIPTION}

**核心价值：** {CORE_VALUE}

**目标用户：** {TARGET_USERS}

---

## 文档索引

本目录包含 {PROJECT_NAME} 的所有技术文档。AI 开发时必须先查阅相关文档，确保理解正确后再进行编码。

---

## 目录结构

```
docs/
├── README.md                          # 本文件 - 文档索引
├── plans/                             # 开发计划（由 AI 生成和执行）
├── specs/                             # 规格文档（必读）
│   ├── PRD.md                         # 产品需求文档
│   └── SAD.md                         # 软件架构设计文档
├── guides/                            # 开发指南
│   ├── AI-DEVELOPMENT-GUIDE.md        # AI 开发指南（TDD）
│   ├── TESTING-GUIDE.md               # 测试规范
│   └── DEPLOYMENT-GUIDE.md            # 部署指南
├── modules/                           # 模块文档
{MODULE_LIST}
├── database/                          # 数据库文档
│   ├── SCHEMA.md                      # 数据库 Schema
│   └── MIGRATIONS.md                  # 迁移记录
└── api/                               # API 文档
    └── api-spec.md                    # API 设计文档
```

---

## 必读文档（按优先级排序）

### 1. 规格文档（specs/）

| 文档 | 说明 | 何时查阅 |
|------|------|----------|
| [PRD.md](./specs/PRD.md) | 产品需求文档 | 了解产品功能和业务需求时 |
| [SAD.md](./specs/SAD.md) | 软件架构设计文档 | 开发任何功能前（必读） |

### 2. 开发指南（guides/）

| 文档 | 说明 | 何时查阅 |
|------|------|----------|
| [AI-DEVELOPMENT-GUIDE.md](./guides/AI-DEVELOPMENT-GUIDE.md) | AI 开发指南（TDD） | 开始编码前（必读） |
| [TESTING-GUIDE.md](./guides/TESTING-GUIDE.md) | 测试规范和示例 | 编写测试用例时 |
| [DEPLOYMENT-GUIDE.md](./guides/DEPLOYMENT-GUIDE.md) | 部署和运维指南 | 部署上线时 |

### 3. 模块文档（modules/）

{MODULE_DOCS_TABLE}

---

## 快速查找

### 按任务类型

| 我要做什么 | 应该看什么 |
|------------|------------|
| 理解产品功能和业务逻辑 | [PRD.md](./specs/PRD.md) |
| 理解整体架构和技术选型 | [SAD.md](./specs/SAD.md) |
| 开发新功能模块 | [SAD.md](./specs/SAD.md) → [AI-DEVELOPMENT-GUIDE.md](./guides/AI-DEVELOPMENT-GUIDE.md) |
{TASK_TYPE_QUICK_LINKS}
| 编写测试用例 | [AI-DEVELOPMENT-GUIDE.md](./guides/AI-DEVELOPMENT-GUIDE.md) + [TESTING-GUIDE.md](./guides/TESTING-GUIDE.md) |
| 数据库 Schema 修改 | [SCHEMA.md](./database/SCHEMA.md) |
| 代码风格问题 | [AI-DEVELOPMENT-GUIDE.md](./guides/AI-DEVELOPMENT-GUIDE.md) → 代码规范章节 |

### 按技术栈

| 技术栈 | 相关文档 |
|--------|----------|
{TECH_STACK_LINKS}

---

## 技术栈

### 前端
{FRONTEND_STACK}

### 后端
{BACKEND_STACK}

### 数据层
{DATA_STACK}

### 基础设施
{INFRASTRUCTURE_STACK}

---

## AI 开发规范

### 开发前必须

1. **查阅 PRD.md**：理解业务需求和功能边界
2. **查阅 SAD.md**：理解整体架构和模块划分
3. **查阅 AI-DEVELOPMENT-GUIDE.md**：遵循 TDD 开发流程和代码规范
4. **确认相关模块文档**：查看 `modules/` 目录中的具体实现规范

### 开发时必须

1. **遵循 TDD 流程**：先写测试，再写实现
2. **遵循代码规范**：{CODE_STYLE_REFERENCE}
3. **单一职责原则**：函数和类保持职责清晰
4. **完善错误处理**：使用自定义异常，明确错误类型
5. **编写注释**：关键方法必须有文档注释

### 开发后必须

1. **更新相关文档**：如果架构、API 或数据模型有变化
2. **运行测试套件**：确保所有测试通过{TEST_COVERAGE_TARGET}
3. **Code Review**：关键模块必须人工审查
4. **记录变更**：在文档末尾的 Changelog 区块记录重大变更

---

## 文档同步规则

| 变更类型 | 需要更新的文档 |
|----------|----------------|
| 新增功能模块 | PRD.md + SAD.md + 对应模块文档 |
| 修改 API 接口 | api-spec.md |
| 修改数据库 Schema | SCHEMA.md + MIGRATIONS.md |
| 新增第三方服务集成 | SAD.md + 对应服务文档 |
| 调整架构设计 | SAD.md |
| 更新测试规范 | TESTING-GUIDE.md |
| 部署流程变更 | DEPLOYMENT-GUIDE.md |

---

## 文档维护

### 文档版本

所有文档应在头部标注最后更新时间，格式：

```markdown
**最后更新：** YYYY-MM-DD
```

### 变更记录

重大变更应记录在文档末尾的 Changelog 区块。

---

**文档中心维护者：** {MAINTAINER}
**创建日期：** {CREATE_DATE}
