# 模塊：技能庫

## 1.範圍

- 小路：`skills/`
- 主要神器：`skills/*/SKILL.md`
- 支援工件：技能本地降價、腳本、提示範本、範例

## 2、責任

技能庫為編碼代理提供可重用的行為契約，包括：

- 構思和規劃工作流程
- 實施工作流程
- 審查工作流程
- 調試和驗證工作流程
- 寫作和維護技能的元技能

## 3.當前技能（核心）

- `brainstorming`
- `writing-plans`
- `executing-plans`
- `subagent-driven-development`
- `requesting-code-review`
- `receiving-code-review`
- `test-driven-development`
- `systematic-debugging`
- `verification-before-completion`
- `dispatching-parallel-agents`
- `using-git-worktrees`
- `finishing-a-development-branch`
- `writing-skills`
- `using-superpowers`

## 4. 接口合約

每個`SKILL.md`必須提供：

1. 前題與`name`和`description`
2. 明確可操作的流程機構
3. 任何引用的支援文件都位於同一技能目錄中

解析和發現依賴：
- `lib/skills-core.js`期望簡單的 frontmatter 鍵`key: value`線

## 5. 依賴關係

- 由平臺層使用（Claude hooks/OpenCode bootstrap/native discovery）
- 由測試套件驗證`tests/`
- 由指令包裝器引用`commands/`

## 6. 質量控制

- 觸發行為檢查：`tests/skill-triggering/`
- 明確請求檢查：`tests/explicit-skill-requests/`
- 端到端行為檢查：`tests/claude-code/`, `tests/subagent-driven-dev/`

## 7. 改變指導

添加或編輯技能時：

1. 將描述重點放在**何時使用**
2. 除非故意，否則避免跨技能的工作流程重複
3. 更新行為改變的測試和文檔
4. 首選增量編輯以避免代理行為中的語意漂移
