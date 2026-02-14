---
name: aile-tdd
description: 面向团队工作流的 TDD 技能（阶段3）。在写任何实现代码前，必须先写失败测试并验证失败，再写最小实现直至通过，最后重构并复验。
---

# Aile：测试驱动开发（aile-tdd）

## 概述

本技能是团队阶段 3 的强制约束：**RED → GREEN → REFACTOR**。

目标不是“写了测试”，而是**用可运行证据证明行为按计划实现**，并与阶段 2 的计划（`docs/plans/{Story-Key}/analysis.md`）一一对应。

## 来源原 Skill

- 来源：`skills/test-driven-development/SKILL.md`
- 策略：保留原 Skill 作为基线与回退路径，本 Skill 复制改写以加入团队流程约束与证据化要求。

## 何时使用

**总是使用：**
- 新功能
- Bug 修复
- 重构
- 行为变更

**例外：**仅在你的人类负责人明确允许时（一次性原型、纯配置变更）。

## 团队增强点（相对原 Skill）

- 计划对齐：每个 RED/GREEN/REFACTOR 循环必须能映射到 `analysis.md` 的某个任务/验收点。
- 证据化：每个任务必须留下“RED 失败输出”和“GREEN 通过输出”的最小证据（日志片段即可）。
- Gate 意识：涉及 UI/交互变更的任务，必须在 G2 通过后进入实现；涉及验收的变更必须为 QA 可测试。

## 铁律

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

如果你在测试之前写了实现代码：删除它，重新开始。

## 执行流程

**开始时声明：**“我正在使用 aile-tdd 技能执行任务，并遵守 RED-GREEN-REFACTOR。”

### Step 1：RED（先写失败测试）

- 写一个最小测试描述“应该发生什么”
- **必须运行测试并确认失败**，且失败原因来自“缺少功能”，不是语法/拼写错误

### Step 2：GREEN（最小实现）

- 写刚好让测试通过的最小实现
- 运行测试并确认通过

### Step 3：REFACTOR（重构）

- 仅在全绿后重构
- 运行测试并确认仍然通过

### Step 4：提交与同步（可选）

- 本仓库策略：除非你的人类负责人明确要求，否则不要在计划执行中自动执行 `git commit`
- 如果团队启用 Jira MCP：在任务完成后同步 Sub-task 状态与测试证据摘要（Comment）
