# Aile Skill Google Drive 同步策略 分析与实施计划

> **给 Claude：** 使用 `project-workflow` 按任务顺序执行本计划。

**Plan ID：** `006-google-drive-sync-for-aile-skills`  
**创建时间：** 2026-02-27  
**最后更新：** 2026-02-27 17:05  
**当前状态：** 已完成  
**负责人：** zhuchunlei  
**目标：** 为 `aile-requirement-analysis` 与 `aile-docs-init` 增加 Google Drive 自动上传规则，确保模块文档与规格文档按产品目录自动归档，并落实历史版本保留策略。  
**架构摘要：** 在两个 Skill 中新增统一的“产品识别 -> 云端目录路由 -> 历史版本轮替 -> 上传动作 -> 权限失败兜底”契约，并通过离线脚本测试保证关键关键词与流程不回退。采用“统一规则文档 + 技能引用”减少重复描述。  
**技术栈：** Markdown Skill、Shell（`bash`/`rg`）、Google Drive Skill（`google-drive`）、Jira MCP（现有）。

---

## 0. 状态管理

### 0.1 整体进度

- [x] 阶段 A：需求分析完成
- [x] 阶段 B：实施计划完成
- [x] 阶段 C：开发与自测完成
- [x] 阶段 D：集成验证完成
- [x] 阶段 E：文档与交付完成

**完成度：** 5/5（100%）

### 0.2 任务状态总览

| 任务ID | 任务名称 | 依赖任务 | 状态 | 负责人 | 开始时间 | 完成时间 | 阻塞原因 | 验证证据 |
|---|---|---|---|---|---|---|---|---|
| T01 | 固化产品识别与云端目录路由契约 | 无 | 已完成 | zhuchunlei | 2026-02-27 16:20 | 2026-02-27 16:45 | 无 | 新增 `docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md` |
| T02 | 新增 Google Drive 同步契约离线测试（RED） | T01 | 已完成 | zhuchunlei | 2026-02-27 16:30 | 2026-02-27 16:35 | 无 | 首次 RED 失败后，GREEN 通过 |
| T03 | 更新 `aile-requirement-analysis`：模块回填 + 自动上传流程 | T02 | 已完成 | zhuchunlei | 2026-02-27 16:46 | 2026-02-27 16:52 | 无 | Skill 新增模块回填与上传契约 |
| T04 | 更新 `aile-docs-init`：`specs/modules` 自动上传流程 | T02 | 已完成 | zhuchunlei | 2026-02-27 16:53 | 2026-02-27 16:57 | 无 | Skill 新增 specs/modules 同步契约 |
| T05 | 新增统一指南并收敛重复规则（DRY） | T03,T04 | 已完成 | zhuchunlei | 2026-02-27 16:40 | 2026-02-27 16:58 | 无 | 两个 Skill 均引用统一指南 |
| T06 | 更新映射与 README 的依赖说明 | T05 | 已完成 | zhuchunlei | 2026-02-27 16:58 | 2026-02-27 17:00 | 无 | README 与映射文档已同步 |
| T07 | 执行文档契约测试与回归验证 | T03,T04,T05,T06 | 已完成 | zhuchunlei | 2026-02-27 17:00 | 2026-02-27 17:05 | 无 | `tests/docs/run-all.sh` 全绿 |

**状态定义：** 待开始 / 进行中 / 阻塞 / 已完成 / 已取消  
**更新规则：** 任务状态每次变化都必须同步更新本表和“执行记录”。

### 0.3 执行记录

| 时间 | 任务ID | 变更 | 操作人 | 备注 |
|---|---|---|---|---|
| 2026-02-27 15:10 | INIT | 初始化计划 | zhuchunlei | 创建计划文档并定义 7 个可追踪任务 |
| 2026-02-27 15:28 | PLAN-UPDATE | 需求确认回填 | zhuchunlei | 确认工程名来源与历史版本保留策略（保留最近 5 版） |
| 2026-02-27 16:35 | T02 | 新增契约测试并验证 RED | zhuchunlei | 首次执行失败：缺少 `docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md` |
| 2026-02-27 16:45 | T01/T05 | 新增统一 Google Drive 指南 | zhuchunlei | 已定义产品路由、工程名规则、历史版本保留 5 版与失败兜底 |
| 2026-02-27 16:52 | T03 | 更新 `aile-requirement-analysis` 契约 | zhuchunlei | 增加模块回填与自动上传流程，引用统一指南 |
| 2026-02-27 16:57 | T04 | 更新 `aile-docs-init` 契约 | zhuchunlei | 增加 `specs/modules` 自动上传与历史版本轮替策略 |
| 2026-02-27 17:00 | T06 | 更新 README 与技能映射 | zhuchunlei | 补充 Drive 指南链接与增强点说明 |
| 2026-02-27 17:05 | T07 | 执行 docs 回归测试 | zhuchunlei | `test-aile-google-drive-sync-contract.sh` 与 `tests/docs/run-all.sh` 全部通过 |
| 2026-02-27 17:18 | FOLLOW-UP | 调整 Skill 本地可访问文档路径 | zhuchunlei | 新增两个 Skill 目录内 `docs-templates/google-drive-sync-integration.md` 并切换引用路径 |
| 2026-02-27 17:21 | FOLLOW-UP | 调整产品归属判定规则 | zhuchunlei | 由“名称包含判断”改为“分析判断，无法确定时询问用户” |
| 2026-02-28 09:59 | FOLLOW-UP | 强化 docs-init 云盘位置与操作约束 | zhuchunlei | 明确固定云盘位置并强调 Google Drive 操作必须全部通过 `google-drive` Skill 执行 |
| 2026-02-28 10:52 | FOLLOW-UP | 强化 Shared Drive 强制定位规则 | zhuchunlei | 禁止全局名称搜索根目录，改为固定根目录 ID + 父目录链路定位 + 上传后父目录校验 |
| 2026-02-28 11:05 | FOLLOW-UP | 扩展 docs-init 同步范围 | zhuchunlei | 同步范围扩展到 `docs/specs|modules|guides|database|api`，并明确排除 `docs/plans/**` |
| 2026-02-28 11:07 | FOLLOW-UP | 升级 docs 全目录规格判定同步 | zhuchunlei | 默认候选改为 `docs/**/*.md`，先判定“是否规格文件”再同步，`docs/` 下其他目录若判定为规格文件也同步 |
| 2026-02-28 11:38 | FOLLOW-UP | 强化 requirement-analysis 规格回补联动 | zhuchunlei | 增加“规格回补评估（是/否）”，先回补规格文件再触发 Google Drive 同步，并支持 docs 其他目录规格判定同步 |

---

## 1. 需求分析

### 1.1 需求摘要

**业务背景：**
- Aile 团队已将 Skill 作为标准交付流程，需把模块文档与规格文档同步到团队 Google Drive 目录，减少人工补传与归档遗漏。
- 当前 Skill 对 Jira MCP 有约束，但缺少 Google Drive 上传契约与产品目录路由规则。

**核心目标：**
- 在 `aile-requirement-analysis` 中支持：模块型 Story 自动回填 `docs/modules/*.md`，且在模块文档变更后自动触发 Google Drive 上传。
- 在 `aile-docs-init` 中支持：产出的 `docs/specs/*`、`docs/modules/*` 自动上传到产品对应目录。
- 上传同名文件时，旧文件重命名为历史版本，仅保留最近 5 个历史版本。

**范围内（In Scope）：**
- [x] 增加产品类型判定规则：Aile / AiPool / 其他。
- [x] 增加 Google Drive 目录路由规则：
  - Aile：`公用云端硬碟/NewAile文件/02-功能規格/[工程名字]/modules|specs`
  - AiPool：`公用云端硬碟/AiPool文件/02-功能規格/[工程名字]/modules|specs`
- [x] 明确 `[工程名字]` 来源：优先取当前工作目录名（或当前工程名）。
- [x] 对“其他产品”增加明确的用户确认步骤。
- [x] 增加无权限时的统一提示：检查 `google-drive` Skill 登录账号与权限。
- [x] 增加同名文件处理策略：旧文件转历史并重命名，历史仅保留最近 5 版。
- [x] 增加离线契约测试，防止规则回退。

**范围外（Out of Scope）：**
- [x] 不实现新的 Google Drive MCP/SDK 代码。
- [x] 不改动 Jira Tool 契约本身。
- [x] 不在本计划内实现真实网盘联调（仅脚本文档契约 + 操作指引）。

### 1.2 用户路径与核心交互

| 步骤 | 角色 | 操作 | 系统响应 | 验证点 |
|---|---|---|---|---|
| 1 | 开发者/PM | 调用 `aile-requirement-analysis` 处理模块 Story | Skill 判断为模块功能并更新 `docs/modules/*.md` | 模块文档更新流程被写入 Skill 契约 |
| 2 | Skill | 检测 `docs/modules` 变更并触发 `google-drive` 上传 | 先将同名旧文件转历史，再上传新文件，并清理至最近 5 版历史 | 历史版本轮替规则明确存在 |
| 3 | 开发者/PM | 调用 `aile-docs-init` 产出 PRD/SAD/module | Skill 自动上传到 `specs`/`modules` 目录并执行同名轮替 | `specs` 上传规则存在且目录正确 |
| 4 | Skill | 检测权限不足 | 提示用户确认 google-drive 登录账号/权限 | 权限失败兜底语句存在 |
| 5 | 开发者/PM | 产品名不含 Aile/AiPool | Skill 询问用户确认目标目录 | 存在“其他产品必须确认目录”流程 |
| 6 | Skill | 解析工程名 | 使用当前工作目录或工程名作为 `[工程名字]` | 工程名来源规则明确存在 |

### 1.3 验收标准（AC）草案

| AC-ID | 可测试条目 | 验证方式（自动/手动） | 对应测试 | 状态 |
|---|---|---|---|---|
| AC-01 | `aile-requirement-analysis` 明确“模块 Story -> 回填 `docs/modules/*.md`” | 自动 | `tests/docs/test-aile-google-drive-sync-contract.sh` 关键词断言 | 已验证 |
| AC-02 | `aile-requirement-analysis` 明确“modules 变更 -> 自动上传 Google Drive” | 自动 | 同上 | 已验证 |
| AC-03 | `aile-docs-init` 明确“`specs/modules` 产出后自动上传” | 自动 | 同上 | 已验证 |
| AC-04 | 文档中包含 Aile/AiPool 目录路由与“其他产品需确认”规则 | 自动 | 同上 | 已验证 |
| AC-05 | 文档中包含权限失败提示：确认 `google-drive` Skill 登录账号 | 自动 | 同上 | 已验证 |
| AC-06 | README/映射文档同步更新依赖说明 | 自动 | `tests/docs/test-templates.sh` + `rg` 检查 | 已验证 |
| AC-07 | 文档中明确 `[工程名字]` 来源为当前工作目录或工程名 | 自动 | `tests/docs/test-aile-google-drive-sync-contract.sh` 关键词断言 | 已验证 |
| AC-08 | 文档中明确同名文件轮替：历史重命名并仅保留最近 5 版 | 自动 | `tests/docs/test-aile-google-drive-sync-contract.sh` 关键词断言 | 已验证 |

### 1.4 风险与应对

| 风险ID | 风险描述 | 影响 | 概率 | 应对策略 | 责任人 |
|---|---|---|---|---|---|
| R-01 | `google-drive` Skill 命令格式在不同环境有差异 | 中 | 中 | 在 Skill 里写“能力契约”而非硬编码命令；提供降级与人工确认 | zhuchunlei |
| R-02 | 云端目录中文名称（简繁体）不一致导致路径匹配失败 | 高 | 中 | 使用固定目录名字符串并在测试中断言关键路径片段 | zhuchunlei |
| R-03 | 共享盘权限不足导致上传失败 | 高 | 高 | 统一失败提示：检查登录账号、共享盘权限、目标文件夹可见性 | zhuchunlei |
| R-04 | `aile-docs-init` 文档体量大，修改易漏项 | 中 | 中 | 先定义统一指南，再在 Skill 中引用，减少散点修改 | zhuchunlei |
| R-05 | 历史版本清理逻辑描述不清导致误删 | 高 | 中 | 明确保留“最近 5 版”且只清理历史文件，不删除当前最新文件 | zhuchunlei |

### 1.5 隐含需求检查清单

- [x] 权限与角色控制（共享盘访问权限、上传权限）
- [x] 空状态（目标目录不存在时先创建）
- [x] 错误状态与重试策略（上传失败给出人工补传步骤）
- [x] 性能目标（文档型操作，非性能敏感）
- [x] 兼容性（Claude/Codex/OpenCode 文本技能一致）
- [x] 可观测性（执行记录中保留上传结果摘要）
- [x] 安全性（不在仓库存储 Drive 凭据）

### 1.6 方案对比与选型结论

**方案 A（不推荐）：在每个 Skill 内重复描述全部路由规则**
- 优点：修改直观。
- 缺点：重复高，后续维护易漂移，违背 DRY。

**方案 B（推荐）：新增统一 Google Drive 同步指南，Skill 仅引用 + 关键步骤约束**
- 优点：规则单一来源、可维护性高、便于测试集中断言。
- 缺点：需要新增一份指南文档并同步引用。

**方案 C（可选）：新增独立“云端同步 Skill”并由其他 Skill 调用**
- 优点：解耦彻底。
- 缺点：当前需求仅限两个 Skill，新增 Skill 成本偏高（YAGNI 风险）。

**最终选型：** B  
**选型理由：** 同时满足 KISS（流程可理解）与 DRY（规则集中维护），并避免过度设计（YAGNI）。

### 1.7 待确认问题

- 已确认 1：`[工程名字]` 取当前工作目录名或当前工程名。
- 已确认 2：上传同名文件时，旧文件重命名为历史版本；仅保留最近 5 个历史版本。

---

## 2. 实施计划

### 2.1 实施顺序与里程碑

| 里程碑 | 目标 | 入口条件 | 完成条件 |
|---|---|---|---|
| M1 | 规则与测试基线完成 | 计划批准 | 新增契约测试并确认 RED |
| M2 | 两个 Skill 契约完成 | M1 完成 | `aile-requirement-analysis` 与 `aile-docs-init` 均包含 Drive 路由与失败兜底 |
| M3 | 文档收敛完成 | M2 完成 | 指南/映射/README 完整一致 |
| M4 | 回归验证完成 | M3 完成 | docs 离线测试全绿 |

### 2.2 任务拆解

### T01 固化产品识别与云端目录路由契约

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 5 分钟  
**依赖任务：** 无  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** 在计划与后续指南中出现完整目录路由矩阵。

**任务目标：**
- 明确 Aile/AiPool/其他产品三类路由规则，定义目录创建、工程名来源、历史版本轮替与失败处理契约。

**涉及文件：**
- 创建：`docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md`
- 修改：`skills/aile-requirement-analysis/SKILL.md`（后续任务引用）
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`

#### RED（先失败）

- [x] 先执行搜索确认当前无统一指南（预期找不到）

**命令：**
```bash
rg -n "GOOGLE-DRIVE-SYNC-INTEGRATION" docs/guides
```

**预期失败：**
```text
(no matches)
```

#### GREEN（最小通过）

- [x] 新增指南骨架并包含三类路由规则

**命令：**
```bash
rg -n "NewAile文件|AiPool文件|02-功能規格|其他产品|当前工作目录|保留最近 5" docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md
```

**预期通过：**
```text
docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md:<line>:...
```

#### REFACTOR（重构与回归）

- [x] 提炼重复描述为“路由决策表 + 失败处理标准句”

**命令：**
```bash
rg -n "路由决策表|权限失败|登录账号|历史版本|保留最近 5" docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md
```

#### 完成定义（DoD）

- [x] 路由规则完整
- [x] 工程名来源规则明确
- [x] 历史版本轮替规则明确（保留最近 5 版）
- [x] 失败处理可操作
- [x] 可被两个 Skill 直接引用

---

### T02 新增 Google Drive 同步契约离线测试（RED）

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 5 分钟  
**依赖任务：** T01  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** 测试脚本先失败后通过。

**任务目标：**
- 建立文档级防回归网，保证关键契约词不可丢失。

**涉及文件：**
- 创建：`tests/docs/test-aile-google-drive-sync-contract.sh`
- 修改：`tests/docs/run-all.sh`（无需改动则记录“无需改动”）
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`

#### RED（先失败）

- [x] 创建断言脚本并立即执行，确认在改 Skill 前失败

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
```

**预期失败：**
```text
FAIL: missing ... google-drive ...
```

#### GREEN（最小通过）

- [x] 后续完成 T03/T04/T05/T06 后再次执行测试应通过

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
```

**预期通过：**
```text
PASS: google-drive sync contract present
```

#### REFACTOR（重构与回归）

- [x] 抽取重复断言函数，提升脚本可维护性

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh && shellcheck tests/docs/test-aile-google-drive-sync-contract.sh
```

#### 完成定义（DoD）

- [x] 测试可稳定复现 RED/GREEN
- [x] 断言覆盖产品路由、权限提示、模块/规格上传

---

### T03 更新 `aile-requirement-analysis`：模块回填 + 自动上传流程

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 5 分钟  
**依赖任务：** T02  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** Skill 中出现模块识别、`docs/modules` 回填、上传和失败兜底步骤。

**任务目标：**
- 在阶段 2 需求接入中加入模块文档同步动作，形成“Jira -> modules -> Drive”的闭环。

**涉及文件：**
- 创建：无
- 修改：`skills/aile-requirement-analysis/SKILL.md`
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`

#### RED（先失败）

- [x] 先执行断言确认当前 Skill 缺少关键词

**命令：**
```bash
rg -n "google-drive|docs/modules|02-功能規格|权限|登录账号" skills/aile-requirement-analysis/SKILL.md
```

**预期失败：**
```text
(no matches for one or more required patterns)
```

#### GREEN（最小通过）

- [x] 增加流程段落：
  - 模块 Story 判定
  - 回填 `docs/modules/{module-name}.md`
  - 变更后上传到产品目录
  - 同名旧文件转历史版本并重命名，清理到最近 5 版
  - 无权限时提示检查账号

**命令：**
```bash
rg -n "模块功能|docs/modules/\{module-name\}\.md|google-drive|NewAile文件|AiPool文件|其他产品|登录账号|当前工作目录|历史版本|保留最近 5" skills/aile-requirement-analysis/SKILL.md
```

**预期通过：**
```text
skills/aile-requirement-analysis/SKILL.md:<line>:...
```

#### REFACTOR（重构与回归）

- [x] 引用统一指南，避免在 Skill 内重复长路径说明

**命令：**
```bash
rg -n "GOOGLE-DRIVE-SYNC-INTEGRATION|目录路由" skills/aile-requirement-analysis/SKILL.md
```

#### 完成定义（DoD）

- [x] 需求接入契约包含模块文档回填
- [x] 上传动作和失败兜底可执行
- [x] 同名文件历史轮替策略完整
- [x] 与统一指南无冲突

---

### T04 更新 `aile-docs-init`：`specs/modules` 自动上传流程

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 5 分钟  
**依赖任务：** T02  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** `aile-docs-init` 在文档生成后包含 `specs` 与 `modules` 上传规则。

**任务目标：**
- 在 docs 初始化流程中增加云端归档步骤，确保 PRD/SAD/module 文档自动进入产品目录。

**涉及文件：**
- 创建：无
- 修改：`skills/aile-docs-init/SKILL.md`
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`

#### RED（先失败）

- [x] 先确认现有 Skill 未包含 google-drive 上传契约

**命令：**
```bash
rg -n "google-drive|specs|NewAile文件|AiPool文件|02-功能規格|权限" skills/aile-docs-init/SKILL.md
```

**预期失败：**
```text
(no matches for drive sync contract)
```

#### GREEN（最小通过）

- [x] 在 Phase 4/5 增加上传步骤：
  - 识别产品类型
  - 定位共享盘目标路径
  - 上传 `docs/specs/*.md` 到 `.../[工程名字]/specs`
  - 上传 `docs/modules/*.md` 到 `.../[工程名字]/modules`
  - 同名旧文件转历史版本并重命名，历史仅保留最近 5 版

**命令：**
```bash
rg -n "google-drive|docs/specs/PRD.md|docs/specs/SAD.md|docs/modules|\[工程名字\]/specs|\[工程名字\]/modules|其他产品|当前工作目录|历史版本|保留最近 5" skills/aile-docs-init/SKILL.md
```

**预期通过：**
```text
skills/aile-docs-init/SKILL.md:<line>:...
```

#### REFACTOR（重构与回归）

- [x] 统一“权限失败提示语”，与 `aile-requirement-analysis` 保持一致

**命令：**
```bash
rg -n "请确认 google-drive.*登录账号" skills/aile-docs-init/SKILL.md skills/aile-requirement-analysis/SKILL.md
```

#### 完成定义（DoD）

- [x] `docs-init` 输出与上传路径一一对应
- [x] Aile/AiPool/其他产品分支明确
- [x] 同名文件历史轮替策略完整
- [x] 权限失败提示统一

---

### T05 新增统一指南并收敛重复规则（DRY）

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P1  
**预估耗时：** 4 分钟  
**依赖任务：** T03,T04  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** 两个 Skill 均引用统一指南，重复路径文本显著减少。

**任务目标：**
- 通过单一规则文档减少重复，实现后续目录策略可维护。

**涉及文件：**
- 创建：`docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md`
- 修改：`skills/aile-requirement-analysis/SKILL.md`、`skills/aile-docs-init/SKILL.md`
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`

#### RED（先失败）

- [x] 检查两个 Skill 尚未引用统一指南

**命令：**
```bash
rg -n "GOOGLE-DRIVE-SYNC-INTEGRATION" skills/aile-requirement-analysis/SKILL.md skills/aile-docs-init/SKILL.md
```

**预期失败：**
```text
(no matches)
```

#### GREEN（最小通过）

- [x] 两个 Skill 均出现对指南的引用

**命令：**
```bash
rg -n "GOOGLE-DRIVE-SYNC-INTEGRATION" skills/aile-requirement-analysis/SKILL.md skills/aile-docs-init/SKILL.md docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md
```

**预期通过：**
```text
.../SKILL.md:<line>:...
.../GOOGLE-DRIVE-SYNC-INTEGRATION.md:<line>:...
```

#### REFACTOR（重构与回归）

- [x] 统一术语（产品名称判定、工程名、目标目录、上传结果记录、历史版本）

**命令：**
```bash
rg -n "产品名称判定|工程名字|目标目录|上传结果|历史版本|保留最近 5" docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md
```

#### 完成定义（DoD）

- [x] 规则文档可独立阅读
- [x] Skill 仅保留必要步骤与引用

---

### T06 更新映射与 README 的依赖说明

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P1  
**预估耗时：** 4 分钟  
**依赖任务：** T05  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** 映射文档和 README 与新契约一致。

**任务目标：**
- 更新对外说明，避免“技能已支持但文档未声明”的落差。

**涉及文件：**
- 创建：无
- 修改：`docs/modules/aile-skill-mapping.md`、`README.md`
- 测试：`tests/docs/test-templates.sh`

#### RED（先失败）

- [x] 检查现有映射未描述 google-drive 同步增强

**命令：**
```bash
rg -n "google-drive|云端|NewAile文件|AiPool文件" docs/modules/aile-skill-mapping.md README.md
```

**预期失败：**
```text
(no matches in mapping or incomplete matches)
```

#### GREEN（最小通过）

- [x] 在映射表补充增强点，在 README 增加规则链接

**命令：**
```bash
rg -n "google-drive|GOOGLE-DRIVE-SYNC-INTEGRATION|NewAile文件|AiPool文件" docs/modules/aile-skill-mapping.md README.md
```

**预期通过：**
```text
docs/modules/aile-skill-mapping.md:<line>:...
README.md:<line>:...
```

#### REFACTOR（重构与回归）

- [x] 去重相同描述，避免 README 与映射冲突

**命令：**
```bash
rg -n "目录路由|权限失败|历史版本|保留最近 5" docs/modules/aile-skill-mapping.md README.md docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md
```

#### 完成定义（DoD）

- [x] 对外文档与 Skill 契约一致
- [x] 无矛盾描述

---

### T07 执行文档契约测试与回归验证

**状态：** 已完成  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 5 分钟  
**依赖任务：** T03,T04,T05,T06  
**开始时间：** 2026-02-27 16:20  
**完成时间：** 2026-02-27 17:05  
**阻塞原因：** 无  
**完成证据：** `tests/docs/run-all.sh` 全绿，新增契约测试通过。

**任务目标：**
- 完成本次改动的离线验证闭环。

**涉及文件：**
- 创建：无
- 修改：无
- 测试：`tests/docs/test-aile-google-drive-sync-contract.sh`、`tests/docs/run-all.sh`

#### RED（先失败）

- [x] 在 T03/T04 完成前先执行，确认新增测试有失败记录

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
```

**预期失败：**
```text
FAIL: ...
```

#### GREEN（最小通过）

- [x] 全部修改完成后执行通过

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
bash tests/docs/run-all.sh
```

**预期通过：**
```text
PASS: google-drive sync contract present
PASSED: all offline checks
```

#### REFACTOR（重构与回归）

- [x] 根据失败信息微调关键词断言，避免脆弱匹配

**命令：**
```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
```

#### 完成定义（DoD）

- [x] 本计划 AC 全部可映射到测试
- [x] docs 契约测试通过

---

## 3. 验证与交付

### 3.1 验证清单

- [x] 所有任务状态已闭环（无遗漏）
- [x] 所有 AC 状态为“已验证”
- [x] docs 离线测试通过
- [x] 权限失败提示语与路由规则一致
- [x] README / mapping / guides 与 Skill 同步

### 3.2 验证命令

```bash
bash tests/docs/test-aile-google-drive-sync-contract.sh
bash tests/docs/test-aile-task5.sh
bash tests/docs/test-templates.sh
bash tests/docs/run-all.sh
```

### 3.3 交付说明

- 交付范围：
  - `aile-requirement-analysis` 新增模块文档回填与 Drive 上传契约
  - `aile-docs-init` 新增 `specs/modules` 上传契约
  - 新增 Google Drive 同步规则指南
  - 新增 docs 契约测试并纳入回归
- 未完成项（如有）：真实 Drive 联调（依赖账户权限与网络环境）
- 后续建议：用 1 个真实 Aile Story 与 1 个 AiPool Story 各进行一次端到端演练。

---

## 4. 决策与复盘

### 4.1 关键决策

| 日期 | 决策 | 原因 | 影响 |
|---|---|---|---|
| 2026-02-27 | 采用“统一指南 + Skill 引用”方案 | 降低重复、便于维护，符合 DRY/KISS | 需新增一份指南并补充引用 |
| 2026-02-27 | 产品路由采用“名称包含判定 + 其他产品询问确认” | 与用户要求一致且可执行 | 需在 Skill 中加入询问分支 |
| 2026-02-27 | 权限失败统一提示检查 `google-drive` 登录账号 | 可快速定位常见失败原因 | 提升可观测性与可恢复性 |
| 2026-02-27 | `[工程名字]` 取当前工作目录名或当前工程名 | 用户已确认，减少人工输入成本 | 需在两个 Skill 和指南内统一写法 |
| 2026-02-27 | 同名文件走历史轮替并仅保留最近 5 版 | 用户已确认，需要兼顾可追溯与存储控制 | 需在上传流程中加入“重命名旧文件 + 历史清理”步骤 |

### 4.2 复盘记录

- 做得好的地方：需求边界清晰，目录规则已明确到可测试级别。
- 可改进点：后续可补充真实上传回执模板，减少人工描述差异。
- 下次行动项：在实现阶段补充 1 份“上传失败排查 FAQ”。
