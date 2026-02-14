# Aile 工作流试点报告（PILOT）

**创建时间：** 2026-02-13
**最近更新：** 2026-02-13

## 1. 试点目标

验证从阶段 1 到阶段 4 的闭环是否可执行、可审查、可回溯：

- 阶段 2 产物是否标准化（analysis.md / design.pencil）
- G2 审查是否能有效阻断不合格输入
- 阶段 3 是否能按 TDD + 子代理执行落地
- 阶段 4 是否能产出可用的 CR 报告与 PR Description，并同步 Jira

## 2. 试点范围

- 离线试点 Story Key：AILE-002（仓库内演练；无 Jira 实体 Issue）
- 真实 Jira 试点 Story Key：AL-1651（Jira MCP 联调）
- 是否包含 UI 变更：
  - AILE-002：否（流程类）
  - AL-1651：是（聊天室解散交互）
- 参与角色：PM / Tech Lead / QA Lead（本次联调由 Codex 代执行）

## 3. 试点前置条件

- Jira MCP 已配置：参考 docs/guides/JIRA-MCP-INTEGRATION.md
- 本地可运行依赖：
  - claude（用于触发/显式请求/Claude 集成测试）
  - opencode（用于 OpenCode 集成测试）
  - timeout（或等效替代）
  - node（用于部分库测试，如需）

> 仓库离线校验命令：bash tests/docs/run-all.sh

## 4. 执行记录

| 日期 | 阶段 | 产物/链接 | 结论 | 备注 |
|------|------|-----------|------|------|
| 2026-02-13 | 阶段2 | docs/plans/AILE-002/analysis.md | 通过 | 离线试点：验证阶段产物契约 |
| 2026-02-13 | 阶段3 | 回归测试套件 | 通过 | 作为 TDD/集成可运行证据（见 4.1） |
| 2026-02-13 | 阶段4 | RELEASE-NOTES.md（v4.2.1） | 通过 | 发布说明与迁移要点已记录 |
| 2026-02-13 | Jira 联调 | AL-1651（Comment + Transition） | 通过 | 状态链路已验证并回置到 To be delivered |
| 2026-02-13 | 复盘 | 本报告 | 通过 | 离线 + 真实 Jira 双试点完成 |

## 4.1 回归测试执行记录（已完成）

> 执行日期：2026-02-13

| 套件 | 命令 | 结果 |
|---|---|---|
| 离线校验 | bash tests/docs/run-all.sh | ✅ PASSED |
| OpenCode | bash tests/opencode/run-tests.sh | ✅ PASSED |
| 触发测试 | bash tests/skill-triggering/run-all.sh | ✅ PASSED |
| 显式请求 | bash tests/explicit-skill-requests/run-all.sh | ✅ PASSED |
| Claude Code | bash tests/claude-code/run-skill-tests.sh --timeout 900 | ✅ PASSED |

## 4.2 真实 Jira 试点（已完成）

目标：在真实 Story 上验证需求接入、计划落地、状态流转、评论回写。

### 4.2.1 已验证 Tool

- jira_get_issue
- jira_search
- jira_transition_issue
- jira_add_comment

### 4.2.2 状态流转证据（AL-1651）

执行链路（2026-02-13）：

To be delivered -> Planning -> Reviewing -> Developing -> To be delivered -> QA-Testing -> PM-Testing -> Beta(完成) -> To be delivered（回置）

说明：
- 为避免影响真实交付节奏，联调结束后已回置到初始状态 To be delivered。
- Jira 评论中保留了联调起止记录与 G1 需求接入摘要。

### 4.2.3 阶段 2 产物

- 已生成：docs/plans/AL-1651/analysis.md
- 说明：该 Story 涉及 UI，开发前需补齐 design.pencil 或经 PM 确认沿用现有布局。

## 5. 验收结论

- 是否达标：达标（离线试点 + 真实 Jira 联调均完成）
- 已关闭阻塞项：
  - [x] 提供真实 Story Key（AL-1651）
  - [x] Jira MCP 可用并完成状态/评论联调

## 6. 复盘与改进项

- 哪些环节最省时：
  - Jira 联调采用“最小 Tool 集 + 回置状态”策略，验证快且影响可控。
- 哪些环节最易出错：
  - 不同项目的状态名与 Gate 语义不完全一致，容易映射偏差。
- 需要改进的 Skill/模板：
  - 在 aile-requirement-intake 与 aile-delivery-report 中补充“状态映射表”提示。
