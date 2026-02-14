# aile-writing-plans Jira Sub-task 契约补齐计划

> **给 Claude/Codex：** 必需技能：`project-workflow`（执行）、`aile-writing-plans`（验收）。

**创建时间：** 2026-02-14  
**状态：** 进行中（回归受外部缺失文件阻塞）  
**负责人：** Codex

**目标：** 补齐 `aile-writing-plans` 在 Jira Sub-task 创建上的“文档声明 → 可执行步骤 → 可测试守卫”全链路一致性。  
**架构：** 采用“契约优先 + TDD 守卫 + 最小改动”策略：先定义 Sub-task 契约，再改 Skill 与模板，最后用离线测试锁定行为。  
**技术栈：** Markdown、Shell（`rg`）、Jira MCP（`jira_create_issue`/`jira_update_issue`）。

---

## 📊 整体进度

- [x] 第一部分：现状与差距分析
- [x] 第二部分：实施任务（Skill/模板/测试）
- [x] 第三部分：回归验证（存在外部阻塞）
- [x] 第四部分：交付与启用说明

**完成度：** 4/4（回归有外部阻塞项）

### 任务状态总览

| 任务 | 负责人 | 状态 | 开始 | 完成 | 阻塞原因 |
|---|---|---|---|---|---|
| T1 补齐 Skill 的 Jira 子任务执行步骤 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T2 补齐模板字段与输出契约 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T3 对齐指南/映射/命令文档 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T4 增加离线契约测试（RED→GREEN） | Codex | 阻塞 | 2026-02-14 | - | 全量回归依赖 `docs/plans/AL-1651/analysis.md`，该文件当前在工作区处于删除状态 |
| T5 全量验证与交付说明 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | 已给出启用/验证/回滚说明 |

**状态定义：** 待开始 / 进行中 / 阻塞 / 已完成 / 已取消

---

## 第一部分：现状与差距分析

### 1.1 现状结论

当前仓库里：

- `docs/guides/JIRA-MCP-INTEGRATION.md` 声明 `aile-writing-plans` 负责创建 Sub-task；
- `skills/aile-writing-plans/SKILL.md` 仅写“回写 AC”，没有明确“逐任务调用 `jira_create_issue` 创建 Sub-task”的执行步骤；
- `tests/docs/test-aile-writing-plans.sh` 未校验 Jira 子任务契约，无法防回归。

### 1.2 目标契约（本计划要达成）

`aile-writing-plans` 必须显式包含以下规则：

1. 任务拆解完成后，为每个实施任务创建 Jira Sub-task。
2. 创建动作使用 `jira_create_issue`，并关联父 Story。
3. Sub-task 最小字段契约：`summary`、`description`、`assignee`（可选）、`labels`（至少包含 Story-Key/阶段标签）。
4. 创建结果回填到 `analysis.md` 的“Jira 关联”章节（包含 Sub-task Key 列表）。
5. MCP 失败时必须降级：本地先产出计划并标记“待人工补录 Sub-task”，禁止声称已同步。

### 1.3 范围与非范围（YAGNI）

**In Scope**
- 更新 `aile-writing-plans` 的执行流程与 Jira 子任务契约
- 更新计划模板中的 Jira 关联字段
- 更新离线测试，防止契约回退

**Out of Scope**
- 不改 Jira 工作流配置（状态机/校验器）
- 不实现自动状态流转（由 `aile-subagent-dev` / `aile-tdd` 负责）
- 不引入新的 Jira MCP Tool

### 1.4 UI 设计判定

**本需求无 UI 设计。**
原因：本次是 Skill 与文档契约修正，不涉及可见页面或交互变更。

---

## 第二部分：实施任务

### 任务 T1：补齐 Skill 的 Jira 子任务执行步骤

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`skills/aile-writing-plans/SKILL.md`

**步骤（TDD导向）：**
1. 先在 T4 写失败断言：必须出现 `jira_create_issue`、`Sub-task`、`parent`、`labels`、`assignee` 等关键契约词。
2. 在 Skill 的执行流程新增 Jira 分支步骤：
   - 读取父 Story Key
   - 按任务列表逐条创建 Sub-task
   - 记录成功/失败结果并回填 `analysis.md`
3. 增加失败兜底：MCP 不可用时，明确“仅本地产出 + 人工补录”。

**验收标准：**
- [x] Skill 中有“逐任务创建 Sub-task”的可执行步骤。
- [x] 字段契约（summary/description/labels/assignee/parent）明确。
- [x] 存在 MCP 失败降级说明。

---

### 任务 T2：补齐模板字段与输出契约

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`docs/templates/stage2-analysis-template.md`

**步骤：**
1. 在“Jira 关联”章节新增结构化子任务字段（建议表格）：任务名、Sub-task Key、负责人、状态、备注。
2. 在模板中写明“若启用 Jira MCP，需记录 `jira_create_issue` 执行结果”。
3. 写明失败回填格式：`未创建（原因：xxx，需人工补录）`。

**验收标准：**
- [x] 模板可直接承载 Sub-task 映射结果。
- [x] 模板可区分自动创建成功与人工补录场景。

---

### 任务 T3：对齐指南/映射/命令文档

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`docs/guides/JIRA-MCP-INTEGRATION.md`
- 修改：`docs/modules/aile-skill-mapping.md`
- 修改：`commands/aile-write-plan.md`

**步骤：**
1. 在 Jira 指南明确 `aile-writing-plans` 的创建时机、最小字段、失败兜底。
2. 在 skill mapping 把“Sub-task 映射”升级为“Sub-task 自动创建 + 结果回填”。
3. 在命令描述补充“启用 Jira MCP 时会创建 Sub-task”的提示。

**验收标准：**
- [x] 三处文档术语一致。
- [x] 与现有 `aile-subagent-dev`、`aile-tdd` 的职责边界不冲突。

---

### 任务 T4：增加离线契约测试（RED→GREEN）

**状态：** 阻塞  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** -  
**阻塞原因：** `tests/docs/run-all.sh` 依赖 `docs/plans/AL-1651/analysis.md`，该文件当前在工作区为删除状态

**文件：**
- 修改：`tests/docs/test-aile-writing-plans.sh`
- （可选）新增：`tests/docs/test-aile-writing-plans-jira-contract.sh`

**步骤：**
1. 扩展离线测试断言：`jira_create_issue`、`Sub-task`、`parent`、`labels`、`assignee`、`人工补录` 等关键词必须出现。
2. 首次运行应失败（RED），完成 T1-T3 后应通过（GREEN）。
3. 执行 `bash "tests/docs/run-all.sh"` 做文档全量回归。

**验收标准：**
- [x] 新增断言能定位具体缺失契约。
- [x] 相关测试通过并具备防回退能力（全量回归除外，受外部阻塞）。

---

### 任务 T5：全量验证与交付说明

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`docs/plans/004-aile-writing-plans-jira-subtask-contract.md`

**步骤：**
1. 记录实际验证命令与结果。
2. 回填任务状态总览与执行记录。
3. 输出“启用方式 + 回滚策略（MCP 不可用时）”。

**验收标准：**
- [x] 计划可直接被 `project-workflow` 执行。
- [x] 交付文档包含启用、验证、回滚三要素。

---

## 第三部分：测试与验收

### 3.1 测试清单

- `bash "tests/docs/test-aile-writing-plans.sh"`
- `bash "tests/docs/test-aile-writing-plans-jira-contract.sh"`（如采用新增脚本）
- `bash "tests/docs/run-all.sh"`

### 3.2 测试结果

- ✅ `bash "tests/docs/test-aile-writing-plans.sh"`：通过
- ✅ `bash "tests/docs/test-aile-writing-plans-jira-contract.sh"`：通过
- ⚠️ `bash "tests/docs/run-all.sh"`：失败，原因是 `tests/docs/test-aile-task7.sh` 依赖 `docs/plans/AL-1651/analysis.md`，该文件当前在仓库中被删除（非本任务引入）

### 3.3 最终验收标准（DoD）

- [x] `aile-writing-plans` 已具备可执行的 Sub-task 创建步骤。
- [x] Sub-task 字段契约在 Skill + 模板 + 指南中一致。
- [x] 离线测试可阻止 Jira 子任务契约回退。
- [x] MCP 不可用时有明确降级路径且可审计。
- [ ] 全量 docs 离线回归通过（受外部缺失文件阻塞）

---

## 第四部分：启用、验证与回滚

### 4.1 启用方式

1. 对 Story 执行 `/aile-write-plan`
2. 按 `aile-writing-plans` 流程完成任务拆解并创建 Sub-task
3. 在 `analysis.md` 的 Jira 关联章节回填 Sub-task Key 或失败原因

### 4.2 验证方式

1. 运行 `bash "tests/docs/test-aile-writing-plans.sh"`
2. 运行 `bash "tests/docs/test-aile-writing-plans-jira-contract.sh"`
3. 运行 `bash "tests/docs/run-all.sh"`（若失败先排查非本任务的外部缺失项）

### 4.3 回滚策略

1. MCP 不可用时，保留计划文档产出，标记“未创建（原因：xxx，需人工补录）”
2. 由人工在 Jira 创建 Sub-task，并回填到 `analysis.md`
3. MCP 恢复后再恢复自动创建流程

---

## 第五部分：执行记录

| 日期 | 变更 | 结果 | 备注 |
|---|---|---|---|
| 2026-02-14 | 创建 004 计划草稿 | ✅ 完成 | 待执行 |
| 2026-02-14 | 新增 `tests/docs/test-aile-writing-plans-jira-contract.sh` 并执行 RED | ✅ 完成 | 验证了旧 Skill 缺少 `jira_create_issue` 契约 |
| 2026-02-14 | 补齐 `aile-writing-plans` 的 Sub-task 创建与降级规则 | ✅ 完成 | 新增字段契约与回填规则 |
| 2026-02-14 | 对齐模板/指南/映射/命令文档 | ✅ 完成 | 术语统一为“自动创建 + 结果回填 + 人工补录” |
| 2026-02-14 | 执行 docs 回归测试 | ⚠️ 阻塞 | `run-all.sh` 受 `docs/plans/AL-1651/analysis.md` 缺失影响 |

---

## 附录：参考

- `skills/aile-writing-plans/SKILL.md`
- `docs/guides/JIRA-MCP-INTEGRATION.md`
- `docs/templates/stage2-analysis-template.md`
- `tests/docs/test-aile-writing-plans.sh`
