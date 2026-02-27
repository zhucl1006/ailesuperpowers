# 移除非 aile 前缀 Skills 分析与实施计划

> **给 Claude/Codex：** 使用 `project-workflow` 按任务顺序执行本计划。

**Plan ID：** `005-remove-non-aile-skills`  
**创建时间：** 2026-02-27  
**最后更新：** 2026-02-27 14:40  
**当前状态：** 已完成  
**负责人：** zhuchunlei  
**目标：** 将仓库迁移为 `aile-*` 技能单一命名体系，并消除 `aile-*` 技能对非 `aile-*` 技能的运行时依赖。  
**架构摘要：** 先补齐缺失的 `aile-*` 等价技能，再迁移 bootstrap/命令/测试/文档引用，最后删除非 `aile-*` 技能目录并通过守卫测试。  
**技术栈：** Markdown Skill、Bash、ripgrep、Node/OpenCode 插件、Claude Hook 脚本  

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
| T01 | 建立 aile-only 守卫脚本与基线报告 | 无 | 已完成 | zhuchunlei | 2026-02-27 14:00 | 2026-02-27 14:05 | 无 | `bash tests/docs/test-aile-only-skill-registry.sh --report-only` |
| T02 | 补齐缺失的 aile 替代技能 | T01 | 已完成 | zhuchunlei | 2026-02-27 14:05 | 2026-02-27 14:12 | 无 | 新增 `aile-using-superpowers`、`aile-git-worktrees`、`aile-tdd`、`aile-code-review` |
| T03 | 迁移现有 aile 技能中的非 aile 引用 | T02 | 已完成 | zhuchunlei | 2026-02-27 14:12 | 2026-02-27 14:20 | 无 | `rg` 扫描确认 `skills/aile-*` 无旧运行时引用 |
| T04 | 迁移 bootstrap 到 `aile-using-superpowers` | T02 | 已完成 | zhuchunlei | 2026-02-27 14:20 | 2026-02-27 14:24 | 无 | `tests/opencode/test-plugin-loading.sh` 通过 |
| T05 | 规范命令层与技能命名一致性 | T03 | 已完成 | zhuchunlei | 2026-02-27 14:24 | 2026-02-27 14:28 | 无 | 删除旧命令并统一 `commands/aile-*.md` 调用 |
| T06 | 同步测试套件到 aile-only 语义 | T03,T04,T05 | 已完成 | zhuchunlei | 2026-02-27 14:28 | 2026-02-27 14:35 | 无 | `tests/docs/run-all.sh` 通过；`test-tools.sh` 因本机 OpenCode provider 缺失未全通过 |
| T07 | 删除非 aile 技能目录并通过守卫 | T06 | 已完成 | zhuchunlei | 2026-02-27 14:35 | 2026-02-27 14:37 | 无 | `bash tests/docs/test-aile-only-skill-registry.sh --strict` 通过 |
| T08 | 更新文档与最终回归验证 | T07 | 已完成 | zhuchunlei | 2026-02-27 14:37 | 2026-02-27 14:40 | 无 | 文档已同步；离线与插件加载测试通过 |

**状态定义：** 待开始 / 进行中 / 阻塞 / 已完成 / 已取消  
**更新规则：** 每次状态变化同步更新本表和“执行记录”。

### 0.3 执行记录

| 时间 | 任务ID | 变更 | 操作人 | 备注 |
|---|---|---|---|---|
| 2026-02-27 | INIT | 初始化计划 | zhuchunlei | 形成 aile-only 迁移方案并完成依赖分析 |
| 2026-02-27 14:05 | T01 | 新增守卫脚本 | zhuchunlei | 新增 `tests/docs/test-aile-only-skill-registry.sh` |
| 2026-02-27 14:12 | T02 | 新增替代技能 | zhuchunlei | 补齐 4 个 `aile-*` 基础技能 |
| 2026-02-27 14:24 | T03/T04 | 迁移技能引用与 bootstrap | zhuchunlei | Hook/OpenCode 插件切换为 `aile-using-superpowers` |
| 2026-02-27 14:28 | T05 | 清理命令层 | zhuchunlei | 删除旧命令文件并统一调用入口 |
| 2026-02-27 14:37 | T06/T07 | 完成测试迁移并删除非 aile 技能 | zhuchunlei | `skills/` 已仅保留 `aile-*` |
| 2026-02-27 14:40 | T08 | 文档回填与回归验证 | zhuchunlei | 离线校验通过；记录 OpenCode provider 环境限制 |

---

## 1. 需求分析

### 1.1 需求摘要

**业务背景：**
- 当前仓库同时存在 `aile-*` 与非 `aile-*` 两套技能，命名体系混杂。
- 用户希望移除所有非 `aile` 前缀技能，并确认 `aile-*` 是否依赖这些技能。

**核心目标：**
- 目标 1：`skills/` 目录仅保留 `aile-*` 技能目录。
- 目标 2：`aile-*` 技能、bootstrap、命令、测试、文档全部改为 `aile-*` 引用闭环。

**范围内（In Scope）：**
- [x] 分析 `aile-*` 对非 `aile-*` 的运行时依赖并给出调整方案。
- [x] 新增缺失的 `aile-*` 等价技能（用于替代当前依赖）。
- [x] 删除 `skills/` 下非 `aile-*` 目录并修复仓库内直接引用。
- [x] 更新测试与文档，确保可验证与可维护。

**范围外（Out of Scope）：**
- [x] 不修改历史归档文档的历史事实（如 `docs/plans/20xx-*.md` 的历史引用可保留）。
- [x] 不处理仓库外个人目录（如 `~/.agents/skills`）的迁移。
- [x] 不在本计划内执行发布动作（tag/发布平台同步）。

### 1.2 用户路径与核心交互

| 步骤 | 角色 | 操作 | 系统响应 | 验证点 |
|---|---|---|---|---|
| 1 | 维护者 | 在新会话触发 bootstrap | 自动加载 `aile-using-superpowers` 内容 | Hook/插件读取路径正确 |
| 2 | 开发者 | 调用 `aile-*` 技能执行阶段流程 | 全流程不再依赖非 `aile-*` 技能名 | `skills/aile-*/SKILL.md` 无运行时旧名引用 |
| 3 | 维护者 | 运行回归脚本 | aile-only 守卫与核心测试通过 | 测试脚本全部绿灯 |

### 1.3 验收标准（AC）草案

| AC-ID | 可测试条目 | 验证方式（自动/手动） | 对应测试 | 状态 |
|---|---|---|---|---|
| AC-01 | `skills/` 下无非 `aile-*` 目录 | 自动 | `tests/docs/test-aile-only-skill-registry.sh` | 已验证 |
| AC-02 | `aile-*` 技能无运行时非 `aile-*` 依赖引用 | 自动 | `rg` 规则扫描 + 守卫脚本 | 已验证 |
| AC-03 | Claude/OpenCode bootstrap 改为读取 `aile-using-superpowers` | 自动 | `tests/opencode/test-plugin-loading.sh` + Hook 路径检查 | 已验证 |
| AC-04 | 命令层仅调用存在的 `aile-*` 技能 | 自动 | `rg` + 命令文件一致性检查 | 已验证 |
| AC-05 | 关键测试用例由旧技能名迁移到 `aile-*` 名称后仍通过 | 自动 | `tests/skill-triggering/*`、`tests/explicit-skill-requests/*` | 部分验证（依赖本机 Claude/OpenCode provider） |
| AC-06 | README/模块文档描述与 aile-only 现状一致 | 手动+自动 | 文档审阅 + `rg` 扫描 | 已验证 |

### 1.4 风险与应对

| 风险ID | 风险描述 | 影响 | 概率 | 应对策略 | 责任人 |
|---|---|---|---|---|---|
| R-01 | 直接删除 `using-superpowers` 导致 bootstrap 失效 | 高 | 高 | 先创建 `aile-using-superpowers` 并迁移 hook/plugin，再删除旧目录 | zhuchunlei |
| R-02 | `aile-*` 技能文本仍引用旧技能名导致流程断裂 | 高 | 高 | 建立 `rg` 守卫规则，逐个技能修正后再删旧目录 | zhuchunlei |
| R-03 | 命令与技能名不一致（如 `aile-requirement-intake` vs `aile-requirement-analysis`） | 中 | 高 | 统一命名并增加存在性检查脚本 | zhuchunlei |
| R-04 | 现有测试脚本大量使用旧技能名，迁移后回归失败 | 中 | 高 | 按优先级分批迁移测试，先关键路径后扩展路径 | zhuchunlei |
| R-05 | 外部用户仍使用旧技能名 | 中 | 中 | 在 README/RELEASE-NOTES 明确破坏性变更与迁移映射 | zhuchunlei |

### 1.5 隐含需求检查清单

- [x] 权限与角色控制（无需新增）
- [x] 空状态（技能缺失时给出明确错误）
- [x] 错误状态与重试策略（守卫脚本可定位缺失项）
- [x] 性能目标（`rg` 扫描在本地秒级完成）
- [x] 兼容性（Claude/Codex/OpenCode 三端 bootstrap）
- [x] 可观测性（测试输出明确指出残留旧引用）
- [x] 安全性（仅文档与本地脚本，无敏感数据写入）

### 1.6 `aile-*` 对非 `aile-*` 依赖结论

**迁移前运行时依赖（已完成消除）：**
- `skills/aile-requirement-analysis/SKILL.md`：原引用 `using-git-worktrees`、`writing-plans`
- `skills/aile-executing-plans/SKILL.md`：原引用 `using-git-worktrees`、`writing-plans`、`finishing-a-development-branch`
- `skills/aile-subagent-dev/SKILL.md`：原引用 `superpowers:requesting-code-review`、`superpowers:executing-plans`、`superpowers:finishing-a-development-branch`、`test-driven-development`

**迁移后结论：**
- 以上依赖已全部替换为 `aile-*` 等价能力。
- `skills/` 目录已仅保留 `aile-*`，目标达成。

### 1.7 方案对比与选型结论

**方案 A（不推荐）：直接删除非 `aile-*` 技能**
- 优点：一次性清理快
- 缺点：高概率破坏 bootstrap 与阶段流程

**方案 B（推荐）：替代迁移后删除（分阶段）**
- 优点：可验证、可回滚、风险可控
- 缺点：需要同步修改测试与文档

**方案 C（不满足目标）：保留非 `aile-*` 仅内部使用**
- 优点：兼容成本低
- 缺点：不符合“移除非 aile 前缀技能”的目标

**最终选型：** B  
**选型理由：** 满足用户目标，同时控制中断风险，符合 KISS（分阶段）、YAGNI（仅迁移必要能力）、DRY（统一命名）和可验证性要求。

### 1.8 决策确认

- Q1（已确认）：**不保留**“旧技能名 -> 新 `aile-*` 技能名”的短期别名兼容层。
- 前置约束：本团队技能使用前，要求先完成 superpowers 技能安装；安装失败视为阻塞项处理。

---

## 2. 实施计划

### 2.1 实施顺序与里程碑

| 里程碑 | 目标 | 入口条件 | 完成条件 |
|---|---|---|---|
| M1 | 建立 aile-only 校验框架与替代技能骨架 | 计划批准 | 守卫脚本可运行，缺失替代技能已补齐 |
| M2 | 完成依赖迁移（技能/命令/bootstrap） | M1 完成 | 核心链路全部改为 `aile-*` 引用 |
| M3 | 删除旧技能并完成回归 | M2 完成 | 非 `aile-*` 目录清零，测试与文档一致 |

### T01 建立 aile-only 守卫脚本与基线报告

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 2-5 分钟  
**依赖任务：** 无  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 新脚本可输出“当前非 aile 技能清单”  

**任务目标：**
- 提供自动化守卫，避免迁移后旧技能回流。

**涉及文件：**
- 创建：`tests/docs/test-aile-only-skill-registry.sh`
- 修改：无
- 测试：`tests/docs/test-aile-only-skill-registry.sh`

#### RED（先失败）
- [ ] 运行守卫脚本（文件尚不存在）并确认失败

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh"
```

**预期失败：**
```text
No such file or directory
```

#### GREEN（最小通过）
- [ ] 新增脚本（报告模式）并成功输出当前非 `aile-*` 清单

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --report-only
```

**预期通过：**
```text
NON_AILE_SKILLS:
```

#### REFACTOR（重构与回归）
- [ ] 抽取允许列表与扫描模式参数，保持脚本可复用

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --report-only
```

---

### T02 补齐缺失的 aile 替代技能

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 2-5 分钟  
**依赖任务：** T01  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 缺失技能文件存在且 frontmatter 正确  

**任务目标：**
- 先补齐迁移必需能力，避免删除旧技能后断链。

**涉及文件：**
- 创建：`skills/aile-using-superpowers/SKILL.md`
- 创建：`skills/aile-git-worktrees/SKILL.md`
- 创建：`skills/aile-tdd/SKILL.md`
- 创建：`skills/aile-code-review/SKILL.md`
- 修改：`docs/modules/aile-skill-mapping.md`
- 测试：`tests/docs/test-aile-only-skill-registry.sh`

#### RED（先失败）
- [ ] 检查上述技能文件不存在

**命令：**
```bash
for f in "skills/aile-using-superpowers/SKILL.md" "skills/aile-git-worktrees/SKILL.md" "skills/aile-tdd/SKILL.md" "skills/aile-code-review/SKILL.md"; do test -f "$f" || echo "MISSING:$f"; done
```

**预期失败：**
```text
MISSING:skills/aile-using-superpowers/SKILL.md
```

#### GREEN（最小通过）
- [ ] 创建文件并补齐最小可用流程说明

**命令：**
```bash
for f in "skills/aile-using-superpowers/SKILL.md" "skills/aile-git-worktrees/SKILL.md" "skills/aile-tdd/SKILL.md" "skills/aile-code-review/SKILL.md"; do test -f "$f" || exit 1; done
rg --line-number "^name:\s*aile-" "skills/aile-using-superpowers/SKILL.md" "skills/aile-git-worktrees/SKILL.md" "skills/aile-tdd/SKILL.md" "skills/aile-code-review/SKILL.md"
```

**预期通过：**
```text
name: aile-
```

#### REFACTOR（重构与回归）
- [ ] 统一四个新技能的章节结构与术语

**命令：**
```bash
rg --line-number "^## " "skills/aile-using-superpowers/SKILL.md" "skills/aile-git-worktrees/SKILL.md" "skills/aile-tdd/SKILL.md" "skills/aile-code-review/SKILL.md"
```

---

### T03 迁移现有 aile 技能中的非 aile 引用

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 2-5 分钟  
**依赖任务：** T02  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 目标技能中无非 `aile-*` 运行时引用  

**任务目标：**
- 让 `aile-*` 技能自洽，不再调用旧技能名。

**涉及文件：**
- 修改：`skills/aile-requirement-analysis/SKILL.md`
- 修改：`skills/aile-executing-plans/SKILL.md`
- 修改：`skills/aile-subagent-dev/SKILL.md`
- 修改：`skills/aile-pencil-design/SKILL.md`
- 测试：`tests/docs/test-aile-only-skill-registry.sh`

#### RED（先失败）
- [ ] 扫描非 `aile-*` 运行时引用并确认存在

**命令：**
```bash
rg --line-number --glob "aile-*/SKILL.md" "superpowers:|using-git-worktrees|test-driven-development|requesting-code-review|finishing-a-development-branch|(^|[^a-z-])executing-plans([^a-z-]|$)" "skills"
```

**预期失败：**
```text
skills/aile-.../SKILL.md:<line>:
```

#### GREEN（最小通过）
- [ ] 全量替换为 `aile-*` 等价技能引用

**命令：**
```bash
rg --line-number --glob "aile-*/SKILL.md" "superpowers:|using-git-worktrees|test-driven-development|requesting-code-review|finishing-a-development-branch" "skills"
```

**预期通过：**
```text
(no matches)
```

#### REFACTOR（重构与回归）
- [ ] 统一术语（阶段名、技能名、输出路径）

**命令：**
```bash
rg --line-number "aile-" "skills/aile-requirement-analysis/SKILL.md" "skills/aile-executing-plans/SKILL.md" "skills/aile-subagent-dev/SKILL.md"
```

---

### T04 迁移 bootstrap 到 `aile-using-superpowers`

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 2-5 分钟  
**依赖任务：** T02  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** Hook/插件仅引用 `aile-using-superpowers`  

**任务目标：**
- 消除 bootstrap 对旧 `using-superpowers` 路径依赖。

**涉及文件：**
- 修改：`hooks/session-start.sh`
- 修改：`.opencode/plugins/superpowers.js`
- 修改：`docs/modules/platform-integration.md`
- 修改：`docs/modules/hooks-and-bootstrap.md`
- 测试：`tests/opencode/test-plugin-loading.sh`

#### RED（先失败）
- [ ] 确认代码仍引用旧路径

**命令：**
```bash
rg --line-number "skills/using-superpowers/SKILL.md|using-superpowers" "hooks/session-start.sh" ".opencode/plugins/superpowers.js" "docs/modules/platform-integration.md" "docs/modules/hooks-and-bootstrap.md"
```

**预期失败：**
```text
using-superpowers
```

#### GREEN（最小通过）
- [ ] 修改为 `aile-using-superpowers` 并通过插件加载检查

**命令：**
```bash
rg --line-number "aile-using-superpowers" "hooks/session-start.sh" ".opencode/plugins/superpowers.js"
bash "tests/opencode/test-plugin-loading.sh"
```

**预期通过：**
```text
[PASS]
```

#### REFACTOR（重构与回归）
- [ ] 统一提示文本中的技能名描述

**命令：**
```bash
rg --line-number "using-superpowers|aile-using-superpowers" "hooks/session-start.sh" ".opencode/plugins/superpowers.js"
```

---

### T05 规范命令层与技能命名一致性

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P1  
**预估耗时：** 2-5 分钟  
**依赖任务：** T03  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** `commands/` 仅调用存在的 `aile-*` 技能  

**任务目标：**
- 清理旧命令并修正命名不一致问题。

**涉及文件：**
- 删除：`commands/brainstorm.md`
- 删除：`commands/write-plan.md`
- 删除：`commands/execute-plan.md`
- 修改：`commands/aile-requirement-analysis.md`
- 修改：`commands/aile-tdd.md`
- 修改：`commands/aile-code-review.md`
- 测试：`tests/docs/test-aile-only-skill-registry.sh`

#### RED（先失败）
- [ ] 找出命令层旧技能调用或不存在的目标

**命令：**
```bash
rg --line-number "brainstorming|writing-plans|executing-plans|aile-requirement-intake" "commands"
```

**预期失败：**
```text
commands/...md:<line>:
```

#### GREEN（最小通过）
- [ ] 命令层统一到 `aile-*` 且目标技能存在

**命令：**
```bash
for s in "aile-requirement-analysis" "aile-writing-plans" "aile-executing-plans" "aile-subagent-dev" "aile-tdd" "aile-code-review" "aile-delivery-report"; do test -f "skills/$s/SKILL.md" || echo "MISSING:$s"; done
rg --line-number --glob "aile-*.md" "调用超能力：使用 aile-" "commands"
```

**预期通过：**
```text
(no MISSING)
```

#### REFACTOR（重构与回归）
- [ ] 统一命令 frontmatter 描述风格

**命令：**
```bash
rg --line-number --glob "aile-*.md" "^description:" "commands"
```

---

### T06 同步测试套件到 aile-only 语义

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P1  
**预估耗时：** 2-5 分钟  
**依赖任务：** T03,T04,T05  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 关键测试不再硬编码旧技能名  

**任务目标：**
- 将关键测试入口从旧技能名迁移到 `aile-*`。

**涉及文件：**
- 修改：`tests/skill-triggering/run-all.sh`
- 修改：`tests/explicit-skill-requests/run-all.sh`
- 修改：`tests/opencode/test-tools.sh`
- 修改：`tests/claude-code/test-subagent-driven-development.sh`
- 测试：上述脚本对应执行命令

#### RED（先失败）
- [ ] 确认测试仍依赖旧技能名

**命令：**
```bash
rg --line-number "superpowers:brainstorming|subagent-driven-development|systematic-debugging|writing-plans|executing-plans" "tests"
```

**预期失败：**
```text
tests/...:<line>:
```

#### GREEN（最小通过）
- [ ] 迁移测试数据与断言到 `aile-*` 命名

**命令：**
```bash
bash "tests/opencode/test-tools.sh"
bash "tests/docs/test-aile-writing-plans.sh"
```

**预期通过：**
```text
[PASS]
```

#### REFACTOR（重构与回归）
- [ ] 抽取可复用技能名变量，减少重复硬编码

**命令：**
```bash
rg --line-number "aile-" "tests/skill-triggering" "tests/explicit-skill-requests" "tests/opencode"
```

---

### T07 删除非 aile 技能目录并通过守卫

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P0  
**预估耗时：** 2-5 分钟  
**依赖任务：** T06  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 守卫脚本 strict 模式通过  

**任务目标：**
- 达成用户核心目标：移除 `skills/` 下全部非 `aile-*` 目录。

**涉及文件：**
- 删除：`skills/` 下全部非 `aile-*` 目录
- 修改：`tests/docs/test-aile-only-skill-registry.sh`（如需 strict 模式）
- 测试：`tests/docs/test-aile-only-skill-registry.sh`

#### RED（先失败）
- [ ] strict 检查应先报出旧目录

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --strict
```

**预期失败：**
```text
NON_AILE_FOUND:
```

#### GREEN（最小通过）
- [ ] 删除旧目录后 strict 检查通过

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --strict
```

**预期通过：**
```text
PASS: only aile-* skills found
```

#### REFACTOR（重构与回归）
- [ ] 校验 skills 目录结构简洁且无重复

**命令：**
```bash
find "skills" -maxdepth 1 -mindepth 1 -type d | sort
```

---

### T08 更新文档与最终回归验证

**状态：** 待开始  
**负责人：** zhuchunlei  
**优先级：** P1  
**预估耗时：** 2-5 分钟  
**依赖任务：** T07  
**开始时间：** -  
**完成时间：** -  
**阻塞原因：** 无  
**完成证据：** 文档一致性通过 + 关键测试通过  

**任务目标：**
- 保证仓库对外说明与实现一致，避免后续认知偏差。

**涉及文件：**
- 修改：`README.md`
- 修改：`docs/modules/skills-library.md`
- 修改：`docs/modules/aile-skill-mapping.md`
- 修改：`docs/specs/PRD.md`
- 修改：`docs/specs/SAD.md`
- 修改：`RELEASE-NOTES.md`
- 测试：`tests/docs/test-aile-only-skill-registry.sh` + 核心回归脚本

#### RED（先失败）
- [ ] 扫描文档中残留旧技能主路径引用

**命令：**
```bash
rg --line-number "skills/(brainstorming|writing-plans|executing-plans|subagent-driven-development|using-superpowers)/SKILL.md" "README.md" "docs" ".opencode" "hooks"
```

**预期失败：**
```text
<file>:<line>:
```

#### GREEN（最小通过）
- [ ] 文档同步后执行关键回归

**命令：**
```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --strict
bash "tests/docs/test-aile-writing-plans.sh"
bash "tests/docs/test-aile-writing-plans-jira-contract.sh"
```

**预期通过：**
```text
PASS
```

#### REFACTOR（重构与回归）
- [ ] 清理重复叙述并补充迁移说明

**命令：**
```bash
rg --line-number "迁移|aile-only|breaking change" "README.md" "RELEASE-NOTES.md" "docs/modules"
```

---

## 3. 验证与交付

### 3.1 验证清单

- [x] 所有任务状态已闭环（无遗漏）
- [x] 所有 AC 状态为“已验证”（AC-05 记录环境限制）
- [x] bootstrap 链路（Claude/OpenCode）可用
- [x] `skills/` 目录已达 aile-only
- [x] 文档与代码一致

### 3.2 验证命令

```bash
bash "tests/docs/test-aile-only-skill-registry.sh" --strict
bash "tests/docs/run-all.sh"
bash "tests/docs/test-aile-writing-plans.sh"
bash "tests/docs/test-aile-writing-plans-jira-contract.sh"
bash "tests/opencode/test-plugin-loading.sh"
rg --line-number --glob "!docs/plans/**" "^name: " "skills/aile-*/SKILL.md"
```

### 3.3 交付说明

- 交付范围：aile-only 技能体系迁移方案（含依赖替代、删除策略、验证路径）
- 未完成项（如有）：`tests/opencode/test-tools.sh` 依赖本机 OpenCode provider，当前环境缺少 provider 导致用例 2 失败
- 后续建议：在具备 OpenCode provider 的环境补跑 `tests/opencode/test-tools.sh` 与 Claude 集成类脚本

---

## 4. 决策与复盘

### 4.1 关键决策

| 日期 | 决策 | 原因 | 影响 |
|---|---|---|---|
| 2026-02-27 | 采用“先替代后删除”的分阶段迁移策略 | 直接删除会破坏 bootstrap 与阶段流程 | 提高安全性，增加少量迁移工作 |

### 4.2 复盘记录

- 做得好的地方：先识别运行时依赖，再设计删除步骤，避免盲删。
- 可改进点：后续可将“技能命名一致性检查”前置为 CI 常驻项。
- 下次行动项：执行 `project-workflow` 时按 T01→T08 串行推进，逐任务更新状态表。
