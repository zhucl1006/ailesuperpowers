# Jira MCP 整合指南（Aile）

> 目的：为团队 `aile-*` Skill 提供可复用的 Jira Tool 契约与安全约束。

## 1. 原则

- **最小权限**：为 AI Agent 使用独立账号与最小项目权限
- **不入库**：Token 只能来自环境变量或本地密钥管理
- **可回退**：当 MCP 不可用时，Skill 必须退化为“只产出本地文档 + 人工 Jira 操作”

## 2. 推荐方案

- 方案 B：自建/本地部署 `mcp-atlassian`（可扩展、可审计）

## 3. 最小 Tool 集（契约）

团队 Skill 预期以下 Tool 可用：

- `jira_get_issue`
- `jira_create_issue`
- `jira_update_issue`
- `jira_transition_issue`
- `jira_add_comment`
- `jira_search`
- `jira_link_issue`

## 4. 环境变量约定（示例）

- `JIRA_URL`
- `JIRA_USERNAME`
- `JIRA_API_TOKEN`

> 这些变量只用于本地运行或 CI 注入，**禁止提交到 Git**。

## 5. 典型调用时机

- `aile-requirement-intake`：读取 Story，写入需求摘要 Comment
- `aile-writing-plans`：创建 Sub-task、回写细化后的 Acceptance Criteria
- `aile-tdd` / `aile-subagent-dev`：更新 Sub-task 状态
- `aile-delivery-report`：写入 PR 链接 Comment，流转 Story 状态

### 5.1 `aile-writing-plans` 的 Sub-task 创建契约

- 创建时机：任务拆解完成后、交接开发前
- 调用 Tool：`jira_create_issue`
- 最小字段：
  - `summary`：任务标题
  - `description`：任务说明与验收要点
  - `parent`：父 Story Key
  - `labels`：至少包含 Story-Key 与阶段标签
  - `assignee`：可选
- 结果回填：在 `analysis.md` 记录每个任务的 Sub-task Key 或失败原因
- 降级规则：若 MCP 调用失败，必须标记“未创建（原因：xxx，需人工补录）”

## 6. 失败处理（必须）

- Tool 调用失败：记录失败原因，提示人工补录，不得声称已同步成功
- 状态流转失败：输出当前状态与期望状态，提示检查权限/Validator
