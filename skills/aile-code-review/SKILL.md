---
name: aile-code-review
description: 面向团队工作流的代码评审技能（阶段4）。对照计划与验收标准生成可执行的 CR 报告，重点排查架构偏离与 AI 幻觉代码，并（可选）回写 Jira Comment。
---

# Aile：代码评审（aile-code-review）

## 概述

本技能用于阶段 4 的代码评审（Code Review Gate），输出结构化 CR 报告，覆盖：

- 规格/计划一致性（按 `docs/plans/{Story-Key}/analysis.md`）
- 架构合规（团队约定/模块边界）
- AI 特有风险（幻觉 API/组件、mock 漂移、验证不足）
- 安全性与可维护性

## 来源原 Skill

- 来源：`skills/requesting-code-review/SKILL.md`
- 策略：保留原 Skill 作为基线与回退路径，本 Skill 复制改写以加入团队评审维度与 Jira 同步语义。

## 输入

- 计划：`docs/plans/{Story-Key}/analysis.md`
- 代码变更范围：`BASE_SHA..HEAD_SHA`
-（可选）相关 PR 链接与部署环境信息

## 输出（CR 报告结构）

评审结论必须按严重程度分级：

- 阻塞（必须修复）：安全漏洞、严重 bug、与验收标准不符
- 重要（应修复）：架构偏离、可维护性隐患、明显性能问题
- 次要（建议）：命名、可读性、小重构

每条问题必须包含：

- 文件路径（尽量到具体位置）
- 问题描述与影响
- 推荐修复建议（KISS/YAGNI 优先）
- 是否阻断合并

## 团队增强点（相对原 Skill）

- 强制“对照计划/AC”评审：不允许仅凭感觉通过
- 增加 AI 幻觉排查清单：
  - 调用不存在的 API/组件
  - mock 与接口漂移
  - 验证仅看 200，不验证输出是否反映意图
-（可选）Jira 回写：把 CR 结论摘要写入 Story Comment

## 执行流程

1. 读取 `analysis.md`，提取验收标准与测试用例
2. 对照 diff：逐条验证“实现是否覆盖 AC + TC”
3. 做架构合规性检查（模块边界、职责单一、重复代码、无过度抽象）
4. 输出 CR 报告（按严重程度分组）
5. 若启用 Jira MCP：将摘要写入 Jira Comment，并在阻塞问题修复后重新评审
