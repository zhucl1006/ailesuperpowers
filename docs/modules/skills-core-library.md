# 模組：技能核心庫

## 1.範圍

- 小路：`lib/skills-core.js`
- 語言：JavaScript（ES模塊語法）
- 目的：用於技能元數據解析、發現、解析和內容塑造的共享實用程序

## 2. 導出函數

### `extractFrontmatter(filePath)`

- 讀`SKILL.md`和萃取物`name` + `description`
- 讀取/解析失敗時傳回空值

### `findSkillsInDir(dir, sourceType, maxDepth = 3)`

- 遞迴掃描`SKILL.md`文件
- 返回帶有源標記的技能元數據對象（`personal`或者`superpowers`)

### `resolveSkillPath(skillName, superpowersDir, personalDir)`

- 將技能名稱解析為具體的`SKILL.md`小路
- 支援`superpowers:`強制命名空間
- 默認優先級是個人技能高於超能力技能

### `checkForUpdates(repoDir)`

- 運行輕量級 git fetch/狀態檢查
- 退貨`true`當本地分支位於遠端分支後方時
- 失敗關閉（`false`) 關於超時/網絡/git 錯誤

### `stripFrontmatter(content)`

- 刪除 YAML frontmatter 區塊並僅返回 markdown 正文

## 3. 消費者

- OpenCode 插件（`.opencode/plugins/superpowers.js`）直接使用解析/剝離模式並與此合約保持一致
- OpenCode 測試驗證行為假設（`tests/opencode/test-skills-core.sh`, `tests/opencode/test-priority.sh`)

## 4. 設計限制

- 必須保持輕依賴（僅限 Node 內建）
- 必須安全失敗（格式錯誤或丟失的技能文件不會導致嚴重崩潰）
- 必須與當前的 frontmatter 模式假設保持兼容性

## 5.風險

- Frontmatter 解析器故意簡單；可能不完全支援複雜的 YAML
- 行為變化可能會悄然影響跨集成的技能發現

## 6. 驗證

跑步：

- `tests/opencode/test-skills-core.sh`
- `tests/opencode/run-tests.sh`
