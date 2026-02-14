---
name: aile-requirement-intake
description: 面向团队工作流的需求接入技能（阶段2）。读取 Jira Story 的需求与 UI 示意，结构化输出需求摘要/风险/隐含需求，并（可选）回写 Jira Comment。
---

# Aile：需求接入（aile-requirement-intake）

## 概述

本技能用于阶段 2 的第一步：把 Jira Story 的输入（需求描述、UI 示意、约束）转成可用于计划与设计的结构化材料。

## 来源原 Skill

- 來源：`skills/brainstorming/SKILL.md`
- 策略：保留原 Skill 作为基线与回退路径，本 Skill 复制改写以加入 Jira 输入解析与团队输出格式。

## 输入

- Jira Story：Description、Acceptance Criteria（如有）、附件/链接（UI 示意）
-（可选）相关 Epic / 依赖 Story

## 输出（需求接入摘要）

必须输出以下结构：

1. 需求理解摘要（1-2 段）
2. 用户路径/核心交互（步骤列表）
3. 验收条件（AC）初稿：将业务表述改写成可测试条目
4. 隐含需求清单（例如权限、空状态、错误状态、性能/兼容性）
5. 风险与不确定项（需要 PM 澄清的问题，按优先级排序）
6. 建议的阶段 2 下一步：是否需要 Pencil 设计、是否需要拆子任务

## Jira MCP（可选）

若环境提供 Jira MCP Tool（例如 `mcp-atlassian`），按以下步骤执行：

1. 读取 Story：`jira_get_issue`
2. 将“需求接入摘要”写入 Comment：`jira_add_comment`

> 注意：凭据（API Token）必须通过环境变量注入，不得写入仓库。

## 执行流程

1. 获取 Story Key
2. 读取并复述需求（避免理解偏差）
3. 列出不确定项（一次一个问题，优先多选题）
4. 产出结构化摘要（用于 `aile-writing-plans` 的输入）
