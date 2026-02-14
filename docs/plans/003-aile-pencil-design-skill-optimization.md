# aile-pencil-design Skill 优化计划（MCP 对齐）

> **给 Claude/Codex：** 必需技能：`project-workflow`（执行）、`aile-pencil-design`（验收）。

**创建时间：** 2026-02-14  
**状态：** 进行中（回归受外部缺失文件阻塞）  
**负责人：** 待指定

**目标：** 优化 `skills/aile-pencil-design/SKILL.md`，使其从“原则说明”升级为“可直接执行的 Pencil MCP 作业规范”，并可被离线脚本校验。  
**架构：** 采用“文档契约先行 + 测试守卫 + 渐进改造”方式：先定义新契约与门禁，再更新 Skill 文档，最后用离线检查保证长期不回退。  
**技术栈：** Markdown、Shell（`rg`）、Pencil MCP 工具契约（`open_document`/`get_editor_state`/`batch_get`/`batch_design`/`snapshot_layout`/`get_screenshot`）。

---

## 📊 整体进度

- [x] 第一部分：需求与现状分析
- [x] 第二部分：实施任务（文档与测试）
- [x] 第三部分：回归验证（存在外部阻塞）
- [x] 第四部分：交付与启用说明

**完成度：** 4/4（回归有外部阻塞项）

### 任务状态总览

| 任务 | 负责人 | 状态 | 开始 | 完成 | 阻塞原因 |
|---|---|---|---|---|---|
| T1 基线盘点与差距清单 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T2 重写 Skill 主体（MCP-first） | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T3 对齐关联资产（命令/清单/映射） | Codex | 已完成 | 2026-02-14 | 2026-02-14 | - |
| T4 新增离线契约测试 | Codex | 阻塞 | 2026-02-14 | - | 全量回归依赖 `docs/plans/AL-1651/analysis.md`，该文件当前在工作区处于删除状态 |
| T5 验证与发布说明 | Codex | 已完成 | 2026-02-14 | 2026-02-14 | 已给出启用/验证/回滚说明 |

**状态定义：** 待开始 / 进行中 / 阻塞 / 已完成 / 已取消

---

## 第一部分：需求与现状分析

### 1.1 需求摘要

当前 `skills/aile-pencil-design/SKILL.md` 已具备最小规则（有 UI 时产出 `design.pencil`、无 UI 时显式声明），但缺少可执行层面的细节：

1. 没有“Pencil MCP 可执行性预检”，实际执行容易卡在连接/权限。
2. 没有分批构图与批次门禁，易产生一次性大改和返工。
3. 没有明确“证据化输出契约”（截图、布局检查结果、状态覆盖矩阵）。
4. 现有离线测试仅检查“文件存在+来源段落”，无法防止关键流程退化。

### 1.2 外部基线（Pencil 官方）

> 依据 `docs.pencil.dev`：Pencil 提供面向 AI Coding Agents 的 MCP 集成能力；`.pen` 为可读写的 JSON 设计文件格式，适合协作与版本管理。

据此，本次优化应把 Skill 从“描述型文档”升级为“工具链执行规范”。

### 1.3 范围与非范围（YAGNI）

**In Scope**
- 优化 `skills/aile-pencil-design/SKILL.md` 结构与执行步骤
- 补充/更新相关模板与命令文档的最小必要内容
- 增加离线测试防回退

**Out of Scope**
- 不新增新 MCP 工具
- 不改造业务功能代码
- 不引入新的工作流阶段

### 1.4 UI 设计判定

**本需求无 UI 设计。**
原因：本次仅优化 Skill 文档与校验脚本，不涉及产品页面或交互改版，因此不产出 `.pen` 设计稿。

---

## 第二部分：实施任务

### 任务 T1：基线盘点与差距清单

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 读取：`skills/aile-pencil-design/SKILL.md`
- 读取：`docs/templates/g2-design-review-checklist.md`
- 读取：`tests/docs/test-aile-task6.sh`
- 输出：`docs/plans/003-aile-pencil-design-skill-optimization.md`

**步骤：**
1. 建立“现状 vs 目标”差距矩阵（触发条件、输入契约、执行流程、门禁、DoD、失败兜底）。
2. 将差距映射为可落地改动点（逐条对应具体文件）。
3. 固化验收条目，作为后续 T4 测试断言来源。

**验收标准：**
- [x] 差距点可追踪到具体文件与具体段落。
- [x] 每个差距点有明确“完成定义”。

---

### 任务 T2：重写 Skill 主体（MCP-first）

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`skills/aile-pencil-design/SKILL.md`

**步骤（TDD风格）：**
1. 先在 T4 测试中写入失败断言（例如必须出现“可执行性预检”“分批构图<=25”“每批门禁检查”“失败兜底”）。
2. 按以下结构重写 Skill：
   - 何时使用 / 何时跳过
   - 输入契约（状态矩阵、交互路径、复用策略）
   - MCP 可执行性预检
   - 分批构图流程（结构优先）
   - 每批质量门禁（`snapshot_layout` + `get_screenshot`）
   - 输出契约（`design.pencil` + 分析文档回填）
   - 失败兜底与恢复
   - DoD
3. 确保措辞“可执行、可检查、可交接”，删除冗余与重复内容（KISS/DRY）。

**验收标准：**
- [x] Skill 中明确列出最小 MCP 工具链与调用顺序。
- [x] 至少覆盖正常/空/加载/异常四态要求。
- [x] 包含无 UI 场景的显式决策路径。

---

### 任务 T3：对齐关联资产（命令/清单/映射）

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`commands/aile-pencil-design.md`
- 修改：`docs/templates/g2-design-review-checklist.md`
- 修改：`docs/modules/aile-skill-mapping.md`

**步骤：**
1. 在命令描述中补充“本 Skill 依赖 Pencil MCP 可用”的前置提示。
2. 在 G2 清单中增加可核验项：状态覆盖、失败回路、关键截图/布局检查。
3. 在映射文档中更新 `aile-pencil-design` 的增强点描述（从“约束”升级为“执行规范 + 证据门禁”）。

**验收标准：**
- [x] 三处文档术语一致（MCP、四态覆盖、G2 门禁）。
- [x] 不引入与其它技能冲突的流程定义。

---

### 任务 T4：新增离线契约测试

**状态：** 阻塞  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** -  
**阻塞原因：** `tests/docs/run-all.sh` 依赖 `docs/plans/AL-1651/analysis.md`，该文件当前在工作区为删除状态

**文件：**
- 新增：`tests/docs/test-aile-pencil-design-contract.sh`
- 修改：`tests/docs/test-aile-task6.sh`（可选，保留兼容）

**步骤（先红后绿）：**
1. 新增脚本并先写“必需关键字断言”，首次运行应失败（RED）。
2. 完成 T2/T3 后再运行，断言通过（GREEN）。
3. 执行 `bash "tests/docs/run-all.sh"` 做文档回归。

**验收标准：**
- [x] 新脚本可独立执行，失败信息可定位到缺失契约。
- [ ] 全量 docs 离线检查通过（受外部阻塞）

---

### 任务 T5：验证与发布说明

**状态：** 已完成  
**负责人：** Codex  
**开始时间：** 2026-02-14  
**完成时间：** 2026-02-14  
**阻塞原因：** -

**文件：**
- 修改：`docs/plans/003-aile-pencil-design-skill-optimization.md`

**步骤：**
1. 记录验证命令、结果摘要、残余风险。
2. 给出“如何在新 Story 中启用新 Skill”的最小操作说明。
3. 输出回滚策略（当 MCP 不可用时如何降级到线框说明 + 待补设计）。

**验收标准：**
- [x] 文档可直接作为执行输入给 `project-workflow`。
- [x] 发布说明包含启用、验证、回滚三部分。

---

## 第三部分：测试与验收

### 3.1 测试清单

- `bash "tests/docs/test-aile-pencil-design-contract.sh"`
- `bash "tests/docs/test-aile-task6.sh"`
- `bash "tests/docs/run-all.sh"`

### 3.2 测试结果

- ✅ `bash "tests/docs/test-aile-pencil-design-contract.sh"`：通过
- ✅ `bash "tests/docs/test-aile-task6.sh"`：通过
- ⚠️ `bash "tests/docs/run-all.sh"`：失败，原因是 `tests/docs/test-aile-task7.sh` 依赖 `docs/plans/AL-1651/analysis.md`，而该文件当前在仓库中被删除（非本任务引入）

### 3.3 最终验收标准（DoD）

- [x] `skills/aile-pencil-design/SKILL.md` 已升级为 MCP-first 执行规范。
- [x] 关联文档（command/checklist/mapping）已同步。
- [x] 离线契约测试可阻止关键段落回退。
- [x] 本计划执行记录与状态表已更新。
- [ ] 全量 docs 离线回归通过（受外部缺失文件阻塞）

---

## 第四部分：启用、验证与回滚

### 4.1 启用方式

1. 对新 Story 执行 `/aile-pencil-design`
2. 按 Skill 中的 MCP 预检与分批门禁作图
3. 在 `analysis.md` 回填证据并走 G2 审查

### 4.2 验证方式

1. 运行 `bash "tests/docs/test-aile-pencil-design-contract.sh"`
2. 运行 `bash "tests/docs/test-aile-task6.sh"`
3. 运行 `bash "tests/docs/run-all.sh"`（若失败先排查非本任务的外部缺失项）

### 4.3 回滚策略

1. 若 Pencil MCP 不可用：在 `analysis.md` 标记 `UI 设计阻塞`，产出线框说明 + 状态清单
2. 待 MCP 恢复后补齐 `design.pencil`，并重新执行 G2 审查
3. 若新契约造成执行负担，可临时仅保留核心门禁（预检 + 四态 + 关键截图），后续迭代恢复完整规则

---

## 第五部分：执行记录

| 日期 | 变更 | 结果 | 备注 |
|---|---|---|---|
| 2026-02-14 | 创建 003 计划草稿 | ✅ 完成 | 待进入实施阶段 |
| 2026-02-14 | 新增契约测试 `tests/docs/test-aile-pencil-design-contract.sh` 并先执行 RED | ✅ 完成 | 验证了旧 Skill 缺少 MCP 预检等关键段落 |
| 2026-02-14 | 重写 `skills/aile-pencil-design/SKILL.md` 为 MCP-first 执行规范 | ✅ 完成 | 增加预检、分批构图、门禁、DoD 与兜底策略 |
| 2026-02-14 | 对齐 `commands` / `checklist` / `mapping` 三处关联文档 | ✅ 完成 | 文档术语统一到 MCP + 证据化门禁 |
| 2026-02-14 | 执行 docs 回归测试 | ⚠️ 阻塞 | `run-all.sh` 受 `docs/plans/AL-1651/analysis.md` 缺失影响 |

---

## 附录：参考资料

- Pencil Docs（MCP 集成）：https://docs.pencil.dev/for-developers/ai-integration
- Pencil Docs（.pen 文件格式）：https://docs.pencil.dev/for-developers/pen-files
- 当前待优化文件：`skills/aile-pencil-design/SKILL.md`
