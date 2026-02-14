# 模块：Aile 团队技能映射

> 目的：将团队自定义 `aile-*` Skill 与原生 Superpowers Skill 的来源关系、增强点、负责人和状态固化为可追溯资产。

## 规则

- 每个 `aile-*` Skill 必须在 `SKILL.md` 的显著位置声明：
  - 来源原 Skill（路径）
  - 团队增强点（新增的流程能力）
  - 适用阶段（与你们的阶段 1-4 对齐）
- 默认策略：保留原 Skill，不修改其 `name`；通过新增 `aile-*` Skill 做复制改写。

## 映射表

| 团队 Skill | 来源原 Skill | 阶段 | 团队增强点 | 负责人 | 状态 |
|---|---|---|---|---|---|
| `aile-requirement-intake` | `skills/brainstorming/SKILL.md` | 2 | Jira Story 结构化解析、风险识别、输出需求摘要 |  | 已完成 |
| `aile-writing-plans` | `skills/writing-plans/SKILL.md` | 2 | 输出 `docs/plans/{Story-Key}/analysis.md`、Sub-task 映射、AC 细化回写 |  | 已完成 |
| `aile-tdd` | `skills/test-driven-development/SKILL.md` | 3 | 强制 RED-GREEN-REFACTOR、证据化验证与状态同步 |  | 已完成 |
| `aile-subagent-dev` | `skills/subagent-driven-development/SKILL.md` | 3 | 子任务驱动、双阶段审查对齐团队规范、Jira 状态同步 |  | 已完成 |
| `aile-code-review` | `skills/requesting-code-review/SKILL.md` | 4 | 架构合规、AI 幻觉排查、阻塞分级、Jira Comment 回写 |  | 已完成 |
| `aile-delivery-report` | `skills/finishing-a-development-branch/SKILL.md` | 4 | PR 描述模板化、Story 关联、状态流转建议 |  | 已完成 |
| `aile-pencil-design` | `skills/brainstorming/SKILL.md` + `skills/writing-plans/SKILL.md` | 2 | Pencil MCP 执行规范、分批作图门禁、G2 证据化审查清单 |  | 已完成 |
