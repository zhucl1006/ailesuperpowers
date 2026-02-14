---
name: aile-pencil-design
description: 面向团队工作流的 Pencil 设计技能（阶段2）。基于需求与计划产出 design.pencil（或声明无 UI 设计），并准备 G2 设计审查材料。
---

# Aile：Pencil 设计（aile-pencil-design）

## 概述

当 Story 涉及 UI/交互变更时，本技能用于阶段 2 产出可审查的设计产物：

- `docs/plans/{Story-Key}/design.pencil`（推荐）
- 若不产出，则必须在 `analysis.md` 明确说明“本 Story 无 UI 设计”及原因

并配套 G2 审查清单，确保 PM 能做 UI/UX 临界判断。

## 来源原 Skill

- 來源：`skills/brainstorming/SKILL.md` + `skills/writing-plans/SKILL.md`
- 策略：保留原 Skill 作为基线与回退路径，本 Skill 复制改写聚焦“UI 产物 + G2 审查门禁”。

## 输入

- Jira Story 需求与 UI 示意（原型链接/草图/交互说明）
- 阶段 2 计划（`analysis.md`）中的 UI 设计章节（若已存在）

## 输出契约（必须遵守）

- 产物目录：`docs/plans/{Story-Key}/`
- 设计文件：`design.pencil`（如有 UI 变更）
- 在 `analysis.md` 的“UI 设计”章节记录：
  - 页面结构
  - 核心交互流程
  - 状态设计：正常/空/加载/异常
  - 与 PM UI 示意的对照说明

## 执行流程

1. 判断是否需要 UI 设计
   - 纯后端/数据类：可以不产出 `design.pencil`，但必须在计划中写明
   - UI/交互变更：必须产出 `design.pencil`

2. 产出设计要点
   - 主路径优先
   - 空状态/错误状态必须覆盖
   - 视觉层级与信息密度要可解释

3. 准备 G2 审查材料
   - 确保 PR 中包含：`analysis.md` + `design.pencil`（如有）
   - 参照 `docs/templates/g2-design-review-checklist.md` 自检
