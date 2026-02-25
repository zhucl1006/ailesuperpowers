# Aile Superpowers

Aile Superpowers 是基于 Superpowers 的团队工作流增强版，目标是把 AI 协作开发过程标准化、可追溯、可验收。

它通过一组 `skills/` 下的技能，把需求接入、计划编写、设计产出、开发执行、交付说明串成完整流水线。

## 快速开始

### 1) 安装（按平台）

- Claude Code：
  ```bash
  /plugin marketplace add obra/superpowers-marketplace
  /plugin install superpowers@superpowers-marketplace
  ```
- Codex：见 `docs/README.codex.md`
- OpenCode：见 `docs/README.opencode.md`

### 2) 验证技能可用

在新会话里直接描述任务，例如：

- `请使用 aile-requirement-intake 处理 Jira Story ABC-123`
- `请使用 aile-writing-plans 为 ABC-123 生成执行计划`

如果技能触发成功，代理会按对应 `SKILL.md` 的流程执行并产出文档。

## Aile 工作流（推荐顺序）

1. `aile-docs-init`：项目文档初始化/回补（可选，项目级）
2. `aile-requirement-intake`：需求接入，产出 `analysis.md`
3. `aile-pencil-design`：UI 设计（有 UI 变更时）
4. `aile-writing-plans`：产出可执行 `plan.md`
5. `aile-executing-plans` 或 `aile-subagent-dev`：执行开发任务
6. `aile-delivery-report`：整理 PR 交付说明并回链 Story

---

## `aile-*` 技能使用方法

以下内容基于 `skills/aile-*/SKILL.md` 汇总。

| Skill | 适用阶段 | 何时使用 | 关键输入 | 核心产出 |
|---|---|---|---|---|
| `aile-docs-init`（skill name: `project-docs-init`） | 项目启动前/文档治理 | 新项目建文档，或已有代码回补文档 | 项目需求或现有代码库 | 完整项目文档体系（PRD/SAD/开发指南等） |
| `aile-requirement-intake` | 阶段2 | 接入 Jira Story，澄清需求与风险 | Story 描述、AC、UI 示意 | `docs/plans/{Story-Key}/analysis.md` |
| `aile-pencil-design` | 阶段2 | Story 涉及 UI/交互变更 | `analysis.md`、状态矩阵、交互路径 | `docs/plans/{Story-Key}/design.pen` + `analysis.md` UI 章节 |
| `aile-writing-plans` | 阶段2 | 需要把需求转成可执行任务 | Story-Key、`analysis.md`、UI 方案 | `docs/plans/{Story-Key}/plan.md` |
| `aile-executing-plans` | 阶段3 | 按计划分批执行并设置人工检查点 | `plan.md` | 分批实现与验证结果（按任务推进） |
| `aile-subagent-dev` | 阶段3 | 任务可拆分，适合子代理并行/串行执行 | `analysis.md`、`plan.md` | 任务实现 + 双阶段审查（规格合规→代码质量） |
| `aile-delivery-report` | 阶段4 | 提交 PR 前统一交付材料 | Story-Key、计划/设计引用、验证结果 | PR Description（模板化）+ 可选 Jira 回写 |

### 1) `aile-docs-init`

- 用途：建立或回补项目文档体系。
- 触发语句示例：
  - `创建项目文档`
  - `根据代码回补项目文档`
- 要点：先判断“新项目模式”还是“代码回补模式”，再分阶段问答与产出。

### 2) `aile-requirement-intake`

- 用途：把 Story 输入转成结构化需求分析。
- 触发语句示例：
  - `请使用 aile-requirement-intake 处理 ABC-123`
- 输出要求：必须写入 `docs/plans/{Story-Key}/analysis.md`，包含需求理解、风险、隐含需求、可测试 AC 初稿。

### 3) `aile-pencil-design`

- 用途：UI 设计证据化（MCP-first）。
- 触发语句示例：
  - `请基于 ABC-123 使用 aile-pencil-design 产出 design.pen`
- 输出要求：
  - 有 UI 变更：必须提供 `design.pen`
  - 无 UI 变更：必须在 `analysis.md` 明确写“本 Story 无 UI 设计”及原因。

### 4) `aile-writing-plans`

- 用途：生成可执行的任务计划。
- 触发语句示例：
  - `请使用 aile-writing-plans 为 ABC-123 生成 plan.md`
- 输出要求：`plan.md` 需覆盖任务拆解、测试用例、验收标准、执行顺序与状态管理。

### 5) `aile-executing-plans`

- 用途：按照计划分批执行任务并在批次间复盘。
- 触发语句示例：
  - `请使用 aile-executing-plans 执行 ABC-123 的计划`
- 执行特征：先审查计划，再按批执行，批次完成后等待反馈，循环直至完成。

### 6) `aile-subagent-dev`

- 用途：通过子代理执行任务并做双阶段审查。
- 触发语句示例：
  - `请使用 aile-subagent-dev 执行 ABC-123`
- 审查顺序：
  1. 规格合规审查
  2. 代码质量审查
  3. 不通过则回到实现修复并复审

### 7) `aile-delivery-report`

- 用途：提交 PR 前统一交付内容。
- 触发语句示例：
  - `请使用 aile-delivery-report 生成 PR 描述`
- 模板：`docs/templates/stage3-pr-description-template.md`
- 最低要求：Story 链接、计划/设计引用、变更摘要、验证项勾选。

---

## 端到端调用示例

```text
1) 请使用 aile-requirement-intake 处理 ABC-123，并输出 analysis.md
2) 请使用 aile-pencil-design 为 ABC-123 产出 design.pen（如果无 UI 变更请明确说明）
3) 请使用 aile-writing-plans 为 ABC-123 生成 plan.md
4) 请使用 aile-subagent-dev 按 plan.md 执行开发并完成审查
5) 请使用 aile-delivery-report 生成 PR 描述并附验证清单
```

## 目录结构（关键）

- `skills/`：所有技能定义（含 `aile-*`）
- `docs/templates/`：阶段模板与清单
- `docs/plans/`：按 Story 保存的分析、设计、计划与执行痕迹
- `docs/modules/aile-skill-mapping.md`：Aile 技能映射说明

## 贡献

1. 新增或调整技能：编辑对应 `skills/<skill-name>/SKILL.md`
2. 同步更新文档：至少更新本 `README.md` 与相关模板说明
3. 提交前验证：确保技能描述、产出路径、模板引用一致

## License

MIT
