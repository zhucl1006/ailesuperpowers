# Google Drive 同步集成指南（Aile）

> 目的：为 `aile-requirement-analysis` 与 `aile-docs-init` 提供统一的云端归档契约，避免路径规则散落在多个 Skill 中。  
> 说明：若 Skill 运行环境无法访问项目级 `docs/guides/`，请改用 Skill 目录内副本：`skills/aile-requirement-analysis/docs-templates/google-drive-sync-integration.md` 与 `skills/aile-docs-init/docs-templates/google-drive-sync-integration.md`。

## 1. 适用范围

- 适用 Skill：
  - `aile-requirement-analysis`（模块文档回填后同步）
  - `aile-docs-init`（`specs/modules` 产出后同步）
- 依赖：已安装并可调用 `google-drive` Skill（来源：`sanjay3290/ai-skills`）

## 2. 产品识别与目录路由

### 2.1 产品名称判定

- 先做产品归属分析判断（结合需求描述、现有文档、工程命名）。
- 判断为 Aile：按 Aile 路由。
- 判断为 AiPool：按 AiPool 路由。
- 无法确定：必须先询问用户确认目标目录，再执行上传。

### 2.2 工程名字规则

- `[工程名字]` 优先取当前工作目录名。
- 如果用户明确给出工程名，使用用户给定名称覆盖默认值。

### 2.3 路由决策表

| 产品类型 | 根目录 | 规格目录 | 模块目录 |
|---|---|---|---|
| Aile | `公用云端硬碟/NewAile文件` | `公用云端硬碟/NewAile文件/02-功能規格/[工程名字]/specs` | `公用云端硬碟/NewAile文件/02-功能規格/[工程名字]/modules` |
| AiPool | `公用云端硬碟/AiPool文件` | `公用云端硬碟/AiPool文件/02-功能規格/[工程名字]/specs` | `公用云端硬碟/AiPool文件/02-功能規格/[工程名字]/modules` |
| 其他产品 | 待用户确认 | 待用户确认 | 待用户确认 |

> Aile 的固定目录链接：`https://drive.google.com/drive/folders/1u2I7QtOQDzWnQAVgINZqQbLv0wOjvR_0`

## 3. 上传策略（同名文件版本轮替）

每次上传都必须按以下顺序执行：

1. 在目标目录查找同名文件。
2. 若存在同名文件：
   - 将旧文件重命名为历史版本（建议后缀：`.history-YYYYMMDD-HHmmss`）。
3. 上传新文件，保持原文件名。
4. 清理历史版本：仅保留最近 5 个历史文件，超过 5 个的旧历史文件删除。

约束：
- 只清理历史文件，不删除当前最新文件。
- 不允许“直接覆盖导致丢失历史”。

## 4. `aile-requirement-analysis` 同步契约

当按单个 Story 做需求分析时：

1. 在 `analysis.md` 输出“是否需要回补规格文件（是/否）”及回补文件清单。
2. 若判定为“是”，先回补本次 Story 相关规格文件。
3. 默认候选 `docs/**/*.md`，排除 `docs/plans/**`，仅同步判定为规格文件且本次已回补的文件。
4. 已知目录按固定映射（`specs/modules/guides/database/api`），其他目录按相对路径落位。
5. 应用“同名文件版本轮替”策略（保留最近 5 版）。

## 5. `aile-docs-init` 同步契约

文档生成完成后：

1. 默认候选：`docs/**/*.md`；明确排除 `docs/plans/**`（执行计划文件不上传）。
2. 对每个候选文件先分析是否属于规格文件；仅判定为“是”才上传。
3. 已知目录按固定位置同步：
   - `docs/specs/**/*.md` -> `.../[工程名字]/specs`
   - `docs/modules/**/*.md` -> `.../[工程名字]/modules`
   - `docs/guides/**/*.md` -> `.../[工程名字]/guides`
   - `docs/database/**/*.md` -> `.../[工程名字]/database`
   - `docs/api/**/*.md` -> `.../[工程名字]/api`
4. `docs/` 下其他目录：若判定为规格文件，保留相对目录结构同步到 `.../[工程名字]/{relative-dir}`。
5. 所有上传动作均应用“同名文件版本轮替”策略（保留最近 5 版）。

## 6. 权限失败与降级策略

若调用 `google-drive` Skill 失败或无目录访问权限：

1. 明确说明失败原因（目录不可见 / 无写权限 / Token 失效）。
2. 提示用户确认 `google-drive` Skill 登录账号是否正确，并确认该账号具备共享盘访问权限。
3. 降级为“本地产出成功 + 人工上传待办”，不得声称已上传成功。

建议提示语：

```text
Google Drive 自动上传失败：请确认 google-drive Skill 的登录账号是否正确，
并检查该账号是否有目标共享盘与目录的访问/写入权限。
当前已完成本地文档更新，请按目标路径人工补传。
```
