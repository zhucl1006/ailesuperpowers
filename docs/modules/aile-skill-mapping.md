# 模块：Aile 团队技能映射

> 目的：将团队自定义 `aile-*` Skill 与原生 Superpowers Skill 的来源关系、增强点、负责人和状态固化为可追溯资产。

## 规则

- 每个 `aile-*` Skill 必须在 `SKILL.md` 的显著位置声明：
  - 来源原 Skill（路径）
  - 团队增强点（新增的流程能力）
  - 适用阶段（与你们的阶段 1-4 对齐）
- 默认策略：保留原 Skill，不修改其 `name`；通过新增 `aile-*` Skill 做复制改写。

## 映射表

| 团队 Skill | 来源基线 | 阶段 | 团队增强点 | 负责人 | 状态 |
|---|---|---|---|---|---|
| `aile-requirement-analysis` | superpowers 需求澄清能力（已迁移为 aile-only） | 2 | Jira Story 结构化解析、风险识别、输出需求摘要 |  | 已完成 |
| `aile-writing-plans` | superpowers 计划拆解能力（已迁移为 aile-only） | 2 | 输出 `docs/plans/{Story-Key}/plan.md`、Sub-task 自动创建 + 结果回填、AC 细化回写 |  | 已完成 |
| `aile-pencil-design` | superpowers 需求分析 + 计划能力（已迁移为 aile-only） | 2 | Pencil MCP 执行规范、分批作图门禁、G2 证据化审查清单 |  | 已完成 |
| `aile-executing-plans` | superpowers 执行计划能力（已迁移为 aile-only） | 3 | 分批执行、人工 Gate、证据化验证 |  | 已完成 |
| `aile-subagent-dev` | superpowers 子代理开发能力（已迁移为 aile-only） | 3 | 子任务驱动、双阶段审查对齐团队规范、Jira 状态同步 |  | 已完成 |
| `aile-tdd` | superpowers TDD 能力（已迁移为 aile-only） | 3 | 强制 RED-GREEN-REFACTOR、证据化验证与状态同步 |  | 已完成 |
| `aile-code-review` | superpowers 代码审查能力（已迁移为 aile-only） | 4 | 架构合规、AI 幻觉排查、阻塞分级、Jira Comment 回写 |  | 已完成 |
| `aile-delivery-report` | superpowers 交付收尾能力（已迁移为 aile-only） | 4 | PR 描述模板化、Story 关联、状态流转建议 |  | 已完成 |
| `aile-using-superpowers` | superpowers bootstrap 能力（已迁移为 aile-only） | 0 | 会话启动技能治理、强制技能先行 |  | 已完成 |
| `aile-git-worktrees` | superpowers 工作树隔离能力（已迁移为 aile-only） | 3 | 开发前隔离工作区与安全校验 |  | 已完成 |
