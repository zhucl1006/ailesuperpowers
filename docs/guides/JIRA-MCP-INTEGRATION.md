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

- `aile-requirement-analysis`：读取 Story，产出本地 `analysis.md`；如用户明确要求，可额外生成需求摘要 Comment 的 ADF 草稿
- `aile-writing-plans`：读取 Story 描述与 `analysis.md`，产出 `plan.md`；不负责创建 Sub-task
- `aile-subagent-dev`：更新 Sub-task 状态
- `aile-delivery-report`：写入 PR 链接 Comment，流转 Story 状态

### 5.0 `aile-requirement-analysis` 的 Comment 回填契约

- 职责边界：只做分析并产出 `analysis.md`，不创建 Sub-task
- 缺失 / gap / 补漏类单据：只输出分析，禁止创建 Sub-task
- 不得修改业务代码、测试代码、规格文档、模块文档
- Comment 格式：如用户明确要求准备 Jira Comment，必须先生成 ADF payload
- 工具限制处理：
  - 默认不执行自动回填
  - 若运行环境仅支持 Markdown Comment：禁止自动回填，降级为“本地保留 ADF 内容 + 人工提交”
- 必须在 `analysis.md` 中记录：
  - 单据类型判断
  - 子任务建议与决策
  - 档案系统回补建议
  - ADF payload 或未回填原因（仅当用户要求 Jira Comment 时）

### 5.1 `aile-writing-plans` 的本地计划契约

- 职责边界：读取 Story 描述、现有文档与当前代码，生成 `docs/plans/{Story-Key}/plan.md`
- 优先上下文：`analysis.md`（如存在）
- Story 描述作用：
  - 校验 `analysis.md` 是否偏离原需求
  - 在无 `analysis.md` 时，作为计划主输入
- 当前代码作用：
  - 识别已实现现状、影响范围、复用点与验证入口
- 不负责：
  - 创建 Jira Sub-task
  - 调用 `jira_create_issue`
  - 自动更新 Jira 状态
- 若 `analysis.md` 已确认并包含“档案系统回补建议”：必须把建议转成计划中的显式任务，供执行阶段真实回补
- 若 `analysis.md` 缺失：允许继续生成计划，但必须显式标注为“降级生成”，并补充关键假设、代码现状与待确认项
- 若 `analysis.md` 内容不完整：允许继续生成计划，由计划阶段结合 Story、文档与代码补齐最小必要信息
- 若 `analysis.md` 与 Story 或代码现状冲突：列出冲突点；仅在无法做出低风险判断时停止

## 6. 失败处理（必须）

- Tool 调用失败：记录失败原因，提示人工补录，不得声称已同步成功
- 状态流转失败：输出当前状态与期望状态，提示检查权限/Validator
