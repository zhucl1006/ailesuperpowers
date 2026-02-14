---
name: aile-writing-plans
description: 面向团队工作流的写计划技能（阶段2）。在开发前，将 Jira Story + UI 示意细化为可执行计划，并输出到 docs/plans/{Story-Key}/analysis.md
---

# Aile：写计划（aile-writing-plans）

## 概述

这是团队自有的计划产出技能，用于把阶段 1（PM 需求 + UI 示意）的输入，转化为阶段 2 的标准化产物：

- 计划主入口：`docs/plans/{Story-Key}/analysis.md`
- 可选设计文件：`docs/plans/{Story-Key}/design.pencil`

并确保计划内容可被后续开发技能（TDD / 子代理开发）直接消费。

## 来源原 Skill

- 来源：`skills/writing-plans/SKILL.md`
- 策略：保留原 Skill 作为基线与回退路径，本 Skill 通过复制改写增加团队能力（不修改原 Skill 的 `name`）。

## 何时使用

在以下情形使用：

- 你已经拿到 Jira Story 的需求描述与（至少）UI 示意/交互说明
- 需要产出可被执行的、任务颗粒度 2-5 分钟的实施计划
- 需要把验收标准（AC）从业务视角细化为技术可测试视角，并回写到 Story（如启用 Jira MCP）

## 核心产出契约（必须遵守）

1. 计划文件必须落在：`docs/plans/{Story-Key}/analysis.md`
2. 文件必须包含：
   - 需求理解与风险
   - UI 设计（有 UI 变更则必须有 `design.pencil` 或明确写“本 Story 无 UI 设计”）
   - 任务拆解（每个任务 2-5 分钟）
   - 测试用例与验收标准（可测试、无歧义）
   - AI 执行指引（明确执行顺序、约束、人工 Gate 节点）
3. 每个任务必须以 TDD 方式描述：RED → 验证失败 → GREEN → 验证通过 → REFACTOR → 再次验证

## 执行流程

**开始时声明：**“我正在使用 aile-writing-plans 技能来生成团队计划。”

### Step 0：读取上下文

- 读取 `docs/README.md` 与相关模块文档（如影响范围涉及 `docs/modules/*`）
- 读取（如存在）`docs/specs/PRD.md`、`docs/specs/SAD.md`
- 读取（如存在）本 Story 之前的计划产物（`docs/plans/{Story-Key}/`）

### Step 1：确认 Story-Key 与范围边界

- 明确 Story-Key（例如 `ABC-123`），作为目录名
- 明确“做什么 / 不做什么”（YAGNI：把不需要的需求从计划中删掉）

### Step 2：细化验收标准（AC）

- 将 AC 写成可测试条目（功能、边界、异常、性能/兼容性如适用）
- 每条 AC 必须能映射到至少一个测试用例（TC）

### Step 3：UI 设计分支（可选）

- 如果是 UI 变更：必须产出 `design.pencil` 或者在计划中说明为什么不需要
- 必须覆盖：正常态 / 空状态 / 加载态 / 异常态（如适用）

### Step 4：任务拆解与排序

- 任务粒度：单任务 2-5 分钟
- 输出：每个任务明确文件路径、测试、验证命令、预期输出
- DRY：复用现有模式，不新增不必要抽象

### Step 5：写入计划文件

将内容写入 `docs/plans/{Story-Key}/analysis.md`，并确保其结构符合团队模板（参考 `docs/templates/stage2-analysis-template.md`）。

### Step 6：交接到执行阶段

- 推荐后续执行技能：`aile-tdd` 或 `aile-subagent-dev`
- 明确 Gate：G2（PM/QA 评审）通过后才能进入开发
