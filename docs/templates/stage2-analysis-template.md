# 阶段 2：分析报告模板

> 目标：产出 `docs/plans/{Story-Key}/analysis.md` 作为已确认需求的分析基线，并支撑后续设计与计划拆解。

> Jira Story: {Story-Key}
> 创建日期: YYYY-MM-DD
> 分析负责人: {Name}

---

## 0. 使用说明

- 本模板只用于需求分析与确认，不用于实施执行。
- 本阶段只产出 `analysis.md`，不修改业务代码、测试代码、规格文档、模块文档。
- 若后续需要回补档案系统，只在本文档记录建议，由 `aile-writing-plans` 转成执行任务。

---

## 1. 需求理解与分析

- 需求解读摘要
- 隐含需求与风险
- 与现有功能的关联/影响

## 2. UI 设计（如适用）

- 设计文件：`design.pencil`（如有）
- 页面结构：
- 核心交互流程：
- 状态设计：正常/空/加载/异常
- 与 PM UI 示意对照说明：

> 若本 Story 无 UI 变更，标注“本 Story 无 UI 设计”。

## 3. 测试用例

| 编号 | 场景 | 类型 | 步骤 | 预期结果 |
|------|------|------|------|----------|
| TC01 |      | 核心 |      |          |

## 4. 验收标准（细化后回写 Jira AC）

- [ ] 标准 1（关联 TC 编号）
- [ ] 标准 2

## 5. 子任务建议与决策

- Story Key：{Story-Key}
- 当前阶段：`aile-requirement-analysis`（只分析，不创建 Sub-task）
- 单据类型：缺失类 / 常规需求 / 待确认
- 是否建议后续创建子任务：否 / 是（需用户确认）
- 用户是否已明确授权创建子任务：否（默认） / 是
- 说明：若需要创建子任务，应在 `aile-writing-plans` 阶段处理；本阶段禁止调用 `jira_create_issue`

## 6. 档案系统回补建议

- 是否建议后续回补：是 / 否
- 建议回补文件：
  - `docs/specs/...`
  - `docs/modules/...`
  - `docs/guides/...`
- 回补原因：
- 优先级：高 / 中 / 低
- 执行阶段：`aile-writing-plans` / `aile-executing-plans`
- 说明：本阶段只记录建议，不执行档案修改

## 7. Jira Comment ADF（如需回填）

> 规则：
> - Jira 回填内容必须先生成 ADF payload
> - 若当前工具不支持直接提交 ADF，则只保留在此处，待人工提交
> - 若用户未明确要求 Jira 回填，可留空

```json
{
  "type": "doc",
  "version": 1,
  "content": []
}
```
