# Skill 工程优化与产品化流程对齐（试点 Story）分析与计划书

> Jira Story: AILE-002（离线试点；无 Jira 实体 Issue）
> 创建日期: 2026-02-13
> 开发负责人: Codex（代执行）

本文件用于验证团队化 `aile-*` Skill 工作流在仓库内“可执行、可审查、可回溯”的最小闭环。

---

## 1. 需求理解与分析

### 目标

- 将当前 Skill 工程升级为可支撑「PM→开发→QA→PM」闭环的团队化 AI 开发系统。
- 在不破坏现有核心 Skill 的前提下，提供团队自有的增强 Skill（`aile-*`）与标准化产物模板。

### 关键约束

- KISS/YAGNI：优先增量落地（保留原 Skill + 新增团队 Skill），避免一次性大改。
- 可追溯：每个团队 Skill 必须标注“来源原 Skill + 团队增强点”，并有最小离线回归。
- 不强依赖 Jira：Jira MCP 可选；没有凭据时可回退为“仅生成本地产物 + 人工同步 Jira”。

### 风险与对策

- 风险：不同平台对 Skill 触发行为存在差异。
  - 对策：补充显式请求测试与离线合约检查（`tests/docs/*`）。
- 风险：Jira 自定义字段 ID/工作流状态在不同实例不一致。
  - 对策：在指南中固化“最小 Tool 集”和字段映射建议，Pilot 时以真实环境验证。

## 2. UI 设计（如适用）

本 Story 无 UI 设计（Skill 工程优化/流程对齐类变更）。

## 3. 任务拆解

| 序号 | 任务名称 | 描述 | 依赖 | 预估复杂度 |
|------|----------|------|------|------------|
| T1 | 模板与映射基线 | 建立阶段产物模板与 `aile-*` 映射文档 | — | 中 |
| T2 | `aile-writing-plans` | 产出 `docs/plans/{Story-Key}/analysis.md` 的团队契约 | T1 | 中 |
| T3 | `aile-tdd` / `aile-subagent-dev` | 强制 TDD 与子代理开发规范 | T2 | 中 |
| T4 | `aile-code-review` / `aile-delivery-report` | 评审报告与交付（PR 描述）模板对齐 | T3 | 中 |
| T5 | Jira MCP / `aile-requirement-intake` | Jira Tool 契约与需求接入 Skill | T4 | 中 |
| T6 | `aile-pencil-design` / G2 清单 | 设计门禁清单与可选设计产物约束 | T2,T5 | 低 |
| T7 | 全流程回归与试点报告 | 运行回归套件、形成试点报告与发布说明 | T1-T6 | 中 |

## 4. 接口与数据流设计

- 输入：计划文件 / Story 输入（离线或 Jira 获取）
- 处理：按 `aile-*` Skill 约束生成/执行产物
- 输出：
  - 阶段 2：`docs/plans/{Story-Key}/analysis.md`（本文件）
  - 阶段 2（可选）：`design.pencil` 或“无 UI 设计”声明
  - 阶段 3：TDD 证据、测试结果、变更 diff
  - 阶段 4：CR 报告、PR Description、（可选）Jira Comment/状态同步

## 5. 测试用例

| 编号 | 场景 | 类型 | 步骤 | 预期结果 |
|------|------|------|------|----------|
| TC01 | 产物模板齐备 | 核心 | 运行 `tests/docs/run-all.sh` | 全部 PASSED |
| TC02 | Skill 触发/显式请求回归 | 核心 | 运行 `tests/skill-triggering/run-all.sh` 与 `tests/explicit-skill-requests/run-all.sh` | 全部 PASSED |
| TC03 | Claude Code 集成回归 | 回归 | 运行 `tests/claude-code/run-skill-tests.sh --timeout 900` | 全部 PASSED |
| TC04 | OpenCode 集成回归 | 回归 | 运行 `tests/opencode/run-tests.sh` | 全部 PASSED |

## 6. 验收标准（细化后回写 Jira AC）

> 离线试点：本节作为“可测试”的验收清单；真实 Jira Pilot 时回写到 Story 的 Acceptance Criteria 字段。

- [ ] AC1：`aile-*` Skill 与模板文件齐备，且可由离线合约检查通过（TC01）
- [ ] AC2：核心触发/显式请求/集成回归全部通过（TC02~TC04）
- [ ] AC3：`RELEASE-NOTES.md` 记录上线说明与迁移要点
- [ ] AC4：试点报告可复用，且记录到 `docs/plans/PILOT-STORY-REPORT.md`

## 7. AI 执行指引

- 执行顺序：T1 → T2 → T3 → T4 → T5 → T6 → T7
- TDD 约束：涉及脚本/工具行为的变更优先补回归测试；文档类变更优先补离线合约检查。
- 关键约束：避免覆盖/重命名原 Skill；新增能力优先以 `aile-*` 形式落地。
- 人工介入节点：
  - G2：若 Story 涉及 UI，PM 必须基于 `g2-design-review-checklist.md` 审查后才能进入开发。
  - Jira：真实 Pilot 需提供 Story Key 与 MCP 凭据/环境，验证状态流转与 Comment 回写。

## 8. Jira 关联

- Story Key：AILE-002（离线试点；无 Jira 实体 Issue）
- 子任务列表：离线试点不创建 Jira Sub-task（真实 Pilot 执行时创建）
- G2 审查 PR：离线试点不提交 PR（真实 Pilot 执行时补齐）

