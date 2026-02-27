# 超能力發行說明

## v4.2.2 (2026-02-27)

### 重大變化

**Aile-only 技能命名落地（破壞性變更）**

本版本將倉庫技能體系正式收斂為 `aile-*` 前綴，移除 `skills/` 下所有非 `aile-*` 目錄，並同步完成 bootstrap、命令層、文檔與測試引用遷移。

- 刪除非 `aile-*` 技能目錄（含 `using-superpowers`、`writing-plans`、`subagent-driven-development` 等）
- 新增並啟用 `aile-using-superpowers` 作為啟動引導技能
- 新增 `aile-git-worktrees`、`aile-tdd`、`aile-code-review`，補齊原有依賴能力
- Hook 與 OpenCode 外掛改為讀取 `skills/aile-using-superpowers/SKILL.md`
- 命令層刪除舊入口（`brainstorm.md`、`write-plan.md`、`execute-plan.md`）

### 遷移說明

- 若你仍在使用舊技能名，請改為對應的 `aile-*` 名稱
- 若你依賴 OpenCode bootstrap，請確認安裝後存在：
  - `~/.config/opencode/superpowers/skills/aile-using-superpowers/SKILL.md`

### 測試

- ✅ `bash "tests/docs/run-all.sh"`
- ✅ `bash "tests/opencode/test-plugin-loading.sh"`
- ✅ `bash "tests/opencode/test-skills-core.sh"`
- ⚠️ `bash "tests/opencode/test-tools.sh"` 依賴本機 OpenCode provider；在無 provider 環境下未完全通過

## v4.2.1 (2026-02-13)

### 改進

**Aile：新增團隊化工作流技能（`aile-*`）與階段產物模板**

此版本在不破壞既有 Superpowers 核心技能的前提下，引入「保留原 Skill + 新增團隊 Skill」的增量改造策略，讓團隊可逐步對齊你們的 PM→開發→QA→PM 閉環流程：

- 新增 `skills/aile-*` 系列技能（需求接入、計畫、TDD、子代理開發、CR、交付、設計門禁）
- 新增階段模板：`docs/templates/`（Story/分析計畫/PR 描述）與 G2 設計審查清單
- 新增技能映射文件：`docs/modules/aile-skill-mapping.md`（來源追溯與團隊增強點）
- 新增 Jira MCP 整合指南：`docs/guides/JIRA-MCP-INTEGRATION.md`（工具契約與安全注入約束）
- 新增試點報告模板：`docs/plans/PILOT-STORY-REPORT.md`（端到端試點記錄入口）
- 完成 AL-1651 真實 Jira 聯調試點（狀態流轉 + Comment 回寫），並補充 `docs/plans/AL-1651/analysis.md`

### 測試

**新增離線合約校驗（不依賴外部 CLI）**

增加 `tests/docs/` 以離線方式校驗核心產物（模板、技能文件與關鍵標記）是否存在，作為 CI/本地最小回歸門檻：

- `bash "tests/docs/run-all.sh"`

並對部分整合測試腳本做了更健壯的行為對齊，以降低不同環境下的波動性（例如本機外掛路徑指定、觸發行為回退判斷等）。

## v4.2.0 (2026-02-05)

### 重大變化

**Codex：用本機技能發現替換了 bootstrap CLI**

`superpowers-codex` 引導 CLI、Windows `.cmd` 包裝器和相關引導內容文件已被刪除。 Codex 現在通過 `~/.agents/skills/superpowers/` 符號鏈接使用本機技能發現，因此不再需要舊的 `use_skill`/`find_skills` CLI 工具。

安裝現在只需克隆+符號鏈接（記錄在INSTALL.md）。不需要 Node.js 依賴項。舊的 `~/.codex/skills/` 路徑已棄用。

### 修復

**Windows：修復了 Claude Code 2.1.x 鉤子執行 (#331)**

Claude Code 2.1.x 更改了掛鉤在 Windows 上的執行方式：它現在自動檢測命令中的 `.sh` 文件並在前面添加 `bash`。這打破了多語言包裝模式，因為 `bash "run-hook.cmd" session-start.sh` 嘗試將 `.cmd` 文件作為 bash 腳本執行。

修復：hooks.json 現在直接呼叫session-start.sh。 Claude Code 2.1.x 自動處理 bash 呼叫。還添加了 .gitattributes 以強制 shell 腳本使用 LF 行結尾（修復 Windows 簽出上的 CRLF 問題）。

**Windows：SessionStart 掛鉤運行非同步以防止終端凍結（#404、#413、#414、#419）**

同步 SessionStart 掛鉤阻止 TUI 在 Windows 上進入原始模式，並凍結所有鍵盤輸入。非同步運行鉤子可以防止凍結，同時仍注入超能力上下文。

**Windows：固定 O(n^2) `escape_for_json` 性能**

由於子字符串複製開銷，在 bash 中使用 `${input:$i:1}` 的逐字符循環的時間複雜度為 O(n^2)。在 Windows Git Bash 上，這花了 60 多秒。替換為 bash 參數替換 (`${s//old/new}`)，它將每個模式作為單個 C 級傳遞運行 — 在 macOS 上快 7 倍，在 Windows 上快得多。

**Codex：修復了 Windows/PowerShell 呼叫（#285、#243）**

- Windows 不尊重 shebangs，因此直接調用無擴展名 `superpowers-codex` 腳本會觸發“打開方式”對話框。所有調用現在都以 `node` 為前綴。
- 修復了 Windows 上的 `~/` 路徑擴展 — 當作為參數傳遞給 `node` 時，PowerShell 不會擴展 `~`。更改為`$HOME`，它可以在 bash 和 PowerShell 中正確擴展。

**Codex：修復了安裝程式中的路徑解析**

使用 `fileURLToPath()` 取代手動 URL 路徑名稱解析，以正確處理所有平臺上包含空格和特殊字元的路徑。

**法典：修復了寫作技能中過時的技能路徑**

將`~/.codex/skills/` 參考（已棄用）更新為`~/.agents/skills/` 本機發現。

### 改進

**實施前現在需要工作樹隔離**

添加`using-git-worktrees` 作為`subagent-driven-development` 和`executing-plans` 的必需技能。實施工作流程現在明確要求在開始工作之前設置一個獨立的工作樹，以防止直接在主幹上進行意外工作。

**主要分支保護軟化為需要明確同意**

現在，這些技能不再完全禁止主要分支的工作，而是在使用者明確同意的情況下允許它。更加靈活，同時仍確保用戶瞭解其意義。

**簡化安裝驗證**

從驗證步驟中刪除了 `/help` 命令檢查和特定斜槓命令清單。技能主要是透過描述您想要執行的操作來呼叫的，而不是透過執行特定​​命令來呼叫。

**Codex：澄清引導程式中的子代理程式工具對應**

改進了有關 Codex 工具如何對應到子代理程式工作流程的 Claude Code 等效項的文件。

### 測試

- 添加了子代理驅動開發的工作樹需求測試
- 添加了主分支紅旗警告測試
- 修復了技能識別測試斷言中的大小寫敏感性

---

## v4.1.1 (2026-01-23)

### 修復

**OpenCode：根據官方文檔在 `plugins/` 目錄上進行標準化 (#343)**

OpenCode 的官方文件使用`~/.config/opencode/plugins/`（複數）。我們的文件以前使用`plugin/`（單數）。雖然 OpenCode 接受這兩種形式，但我們已經對官方約定進行了標準化以避免混淆。

變化：
- 在回購結構中將`.opencode/plugin/`重命名為`.opencode/plugins/`
- 更新了所有平臺上的所有安裝文檔（INSTALL.md、README.opencode.md）
- 更新了測試腳本以匹配

**OpenCode：修復了符號鏈接指令（#339、#342）**

- 在`ln -s`之前加入了明確的`rm`（修正了重新安裝時的「檔案已存在」錯誤）
- 新增了 INSTALL.md 中缺少的技能符號連結步驟
- 從已棄用的 `use_skill`/`find_skills` 更新為本機 `skill` 工具參考

---

## v4.1.0 (2026-01-23)

### 重大變化

**OpenCode：切換到原生技能係統**

Superpowers for OpenCode 現在使用 OpenCode 的原生 `skill` 工具，而不是自定義 `use_skill`/`find_skills` 工具。這是一個更清晰的集成，可與 OpenCode 的內置技能發現配合使用。

**需要遷移：** 技能必須符號連結到`~/.config/opencode/skills/superpowers/`（請參閱更新的安裝文件）。

### 修復

**OpenCode：修復了會話啟動時代理重置的問題 (#226)**

先前使用 `session.prompt({ noReply: true })` 的引導注入方法導致 OpenCode 將所選代理重置為在第一條訊息上「建置」。現在使用`experimental.chat.system.transform`鉤子直接修改系統提示符，沒有副作用。

**OpenCode：修復了 Windows 安裝 (#232)**

- 刪除了對 `skills-core.js` 的依賴（消除了複製文件而不是符號鏈接時損壞的相對導入）
- 添加了 cmd.exe、PowerShell 和 Git Bash 的全面 Windows 安裝文檔
- 記錄了每個平臺的正確符號鏈接與連接用法

**Claude Code：修復了 Claude Code 2.1.x 的 Windows 掛鉤執行**

Claude Code 2.1.x 更改了掛鉤在 Windows 上的執行方式：它現在自動偵測命令中的 `.sh` 檔案並在前面新增 `bash `。這打破了多語言包裝模式，因為 `bash "run-hook.cmd" session-start.sh` 嘗試將 .cmd 檔案作為 bash 腳本執行。

修復：hooks.json 現在直接呼叫session-start.sh。 Claude Code 2.1.x 自動處理 bash 呼叫。還添加了 .gitattributes 以強制 shell 腳本使用 LF 行結尾（修復 Windows 簽出上的 CRLF 問題）。

---

## v4.0.3 (2025-12-26)

### 改進

**針對明確的技能要求強化了使用超能力的技能**

解決了一種故障模式，即使用戶通過名稱明確請求該技能，克勞德也會跳過調用該技能（e.g.，“請使用子代理驅動開發”）。克勞德會想“我知道這意味著什麼”，然後直接開始工作，而不是加載技能。

變化：
- 更新了“規則”以“調用相關或請求的技能”而不是“檢查技能” - 強調主動調用而不是被動檢查
- 增加了“在任何回應或行動之前” - 原來的措辭只提到“回應”，但克勞德有時會在不先回應的情況下採取行動
- 增加了呼叫錯誤技能是可以的保證 - 減少猶豫
- 新增了新的危險訊號：「我知道這代表什麼」→瞭解概念≠使用技能

**添加了明確的技能要求測試**

`tests/explicit-skill-requests/` 中的新測試套件可驗證 Claude 在用戶通過名稱請求技能時是否正確調用技能。包括單圈和多圈測試場景。

## v4.0.2 (2025-12-23)

### 修復

**斜線指令現在僅供使用者使用**

將 `disable-model-invocation: true` 加到所有三個斜線指令（`/brainstorm`、`/execute-plan`、`/write-plan`）。克勞德無法再透過技能工具呼叫這些命令 - 它們僅限於手動使用者呼叫。

基本技能（`superpowers:brainstorming`、`superpowers:executing-plans`、`superpowers:writing-plans`）仍可供 Claude 自主調用。當克勞德呼叫僅重定向到技能的命令時，此更改可以防止混淆。

## v4.0.1 (2025-12-23)

### 修復

**闡明如何獲取克勞德代碼中的技能**

修正了克勞德透過技能工具呼叫技能，然後嘗試單獨讀取技能檔案的令人困惑的模式。 `using-superpowers` 技能現在明確指出技能工具直接加載技能內容，無需讀取文件。

- 在`using-superpowers`中添加了“如何獲取技能”部分
- 修改了指令中的“讀取技能”→“調用技能”
- 更新了斜槓命令以使用完全限定的技能名稱（e.g.、`superpowers:brainstorming`）

**新增了對接收程式碼審查的 GitHub 線程回覆指南** (h/t @ralphbean)

添加了關於回復原始線程中的內嵌評論評論的註釋，而不是作為頂級 PR 評論。

**新增了對寫作技能的自動化文件指導** (h/t @EthanJStark)

增加了關於機械約束應該自動化而不是記錄的指導——保留用於判斷的技能。

## v4.0.0 (2025-12-17)

### 新功能

**子代理驅動開發中的兩階段程式碼審查**

子代理程式工作流程現在在每個任務之後使用兩個單獨的審核階段：

1. **規範合規性審查** - 持懷疑態度的審查者驗證實施是否完全符合規範。捕獲缺失的需求和過度建構。不會相信實施者的報告－閱讀實際代碼。

2. **程式碼品質審查** - 僅在規範合規性通過後運行。審查乾淨的程式碼、測試覆蓋率、可維護性。

這捕獲了常見的故障模式，即程式碼編寫良好但與請求的內容不符。評審是循環的，而不是一次性的：如果評審者發現問題，實施者會修復它們，然後評審者再次檢查。

其他子代理工作流程改進：
- 控制器向工作人員提供完整的任務文本（不是文件引用）
- 工人可以在工作前和工作期間提出澄清問題
- 報告完成前的自我審查清單
- 計劃在開始時讀取一次，提取到TodoWrite

`skills/subagent-driven-development/` 中的新提示範本：
- `implementer-prompt.md` - 包括自我審查清單，鼓勵提問
- `spec-reviewer-prompt.md` - 依要求進行懷疑性驗證
- `code-quality-reviewer-prompt.md` - 標準代碼審查

**調試技術與工具相結合**

`systematic-debugging` 現在捆綁了支持技術和工具：
- `root-cause-tracing.md` - 通過調用堆棧向後追蹤錯誤
- `defense-in-depth.md` - 添加多層驗證
- `condition-based-waiting.md` - 用條件輪詢替換任意超時
- `find-polluter.sh` - 二分腳本來查找哪個測試造成污染
- `condition-based-waiting-example.ts` - 真實調試會話的完整實現

**測試反模式參考**

`test-driven-development` 現在包括`testing-anti-patterns.md` 覆蓋：
- 測試模擬行為而不是真實行為
- 將僅測試方法添加到生產類中
- 在不瞭解依賴關係的情況下進行模擬
- 隱藏結構假設的不完整模擬

**技能測試基礎設施**

用於驗證技能行為的三個新測試框架：

`tests/skill-triggering/` - 在沒有明確命名的情況下驗證簡單提示的技能觸發。測試 6 項技能以確保僅描述就足夠了。

`tests/claude-code/` - 使用 `claude -p` 進行無頭測試的整合測試。透過會話記錄 (JSONL) 分析驗證技能使用。包括用於成本跟蹤的`analyze-token-usage.py`。

`tests/subagent-driven-dev/` - 使用兩個完整的測試項目進行端到端工作流程驗證：
- `go-fractals/` - 使用 Sierpinski/Mandelbrot 的 CLI 工具（10 個任務）
- `svelte-todo/` - 具有 localStorage 和 Playwright 的 CRUD 應用程式（12 個任務）

### 主要變化

**DOT 流程圖作為可執行規範**

使用 DOT/GraphViz 流程圖作為權威流程定義重寫了關鍵技能。散文成為支撐內容。

**描述陷阱**（記錄在`writing-skills`）：發現當描述包含工作流程摘要時，技能描述會覆蓋流程圖內容。克勞德遵循簡短的描述，而不是閱讀詳細的流程圖。修復：描述必須僅觸發（“在 X 時使用”），沒有流程詳細資訊。

**使用超能力時技能優先**

當應用多種技能時，流程技能（頭腦風暴、調試）現在明確優先於實施技能。 “Build X”首先引發頭腦風暴，然後引發領域技能。

**強化腦力激盪觸發**

描述更改為命令式：“您必須在任何創造性工作之前使用它——創建功能、構建組件、添加功能或修改行為。”

### 重大變化

**技能整合** - 合併六項獨立技能：
- `root-cause-tracing`、`defense-in-depth`、`condition-based-waiting` → 捆綁在 `systematic-debugging/` 中
- `testing-skills-with-subagents` → 捆綁在 `writing-skills/` 中
- `testing-anti-patterns` → 捆綁在 `test-driven-development/` 中
- `sharing-skills` 已刪除（已過時）

### 其他改進

- **render-graphs.js** - 從技能中提取點圖並渲染為 SVG 的工具
- **使用超級大國中的合理化表** - 可掃描格式，包括新條目：“我首先需要更多上下文”，“讓我先探索一下”，“這感覺很有成效”
- **docs/testing.md** - 使用 Claude Code 整合測試測試技能的指南

---

## v3.6.2 (2025-12-03)

＃＃＃ 固定的

- **Linux 相容性**：修復了多語言掛鉤包裝器 (`run-hook.cmd`) 以使用 POSIX 相容語法
  - 在第 16 行用標準 `$0` 取代了 bash 特定的 `${BASH_SOURCE[0]:-$0}`
  - 解決了 Ubuntu/Debian 系統上的「錯誤替換」錯誤，其中 `/bin/sh` 是破折號
  - 修復#141

---

## v3.5.1 (2025-11-24)

### 已更改

- **OpenCode Bootstrap Refactor**：從 `chat.message` 掛鉤切換到 `session.created` 事件以進行引導注入
  - Bootstrap 現在通過 `session.prompt()` 和 `noReply: true` 在會話創建時注入
  - 明確告訴模型using-superpowers已經加載，以防止多餘的技能加載
  - 將引導內容生成合併到共享`getBootstrapContent()`幫助程序中
  - 更乾淨的單一實現方法（刪除了後備模式）

---

## v3.5.0 (2025-11-23)

### 添加

- **OpenCode 支持**：OpenCode.ai 的本機 JavaScript 插件
  - 自定義工具：`use_skill` 和`find_skills`
  - 跨上下文壓縮技能持久性的消息插入模式
  - 通過chat.message鉤子自動上下文注入
  - session.compacted 事件自動重新註入
  - 三層技能優先級：項目>個人>超能力
  - 項目本地技能支持 (`.opencode/skills/`)
  - 共享核心模塊 (`lib/skills-core.js`)，用於 Codex 的代碼重用
  - 具有適當隔離的自動化測試套件 (`tests/opencode/`)
  - 特定於平臺的文檔（`docs/README.opencode.md`、`docs/README.codex.md`）

### 已更改

- **重構 Codex 實現**：現在使用共享 `lib/skills-core.js` ES 模塊
  - 消除 Codex 和 OpenCode 之間的代碼重複
  - 技能發現和解析的單一事實來源
  - Codex 通過 Node.js 互操作成功加載 ES 模塊

- **改進文檔**：重寫自述文件以清楚地解釋問題/解決方案
  - 刪除了重複的部分和衝突的信息
  - 添加了完整的工作流程描述（頭腦風暴→計劃→執行→完成）
  - 簡化的平臺安裝說明
  - 強調技能檢查協議而不是自動激活聲明

---

## v3.4.1 (2025-10-31)

### 改進

- 優化超能力引導程序，消除多餘的技能執行。 `using-superpowers` 技能內容現在直接在會話上下文中提供，並明確指導僅將技能工具用於其他技能。這減少了開銷並防止令人困惑的循環，即儘管已經擁有會話啟動時的內容，代理仍會手動執行`using-superpowers`。

## v3.4.0 (2025-10-30)

### 改進

- 簡化`brainstorming`技能以回到原始對話視野。刪除了帶有正式檢查表的重量級 6 階段流程，轉而採用自然對話：一次提出一個問題，然後以 200-300 字的部分展示設計並進行驗證。保留文件和實施移交功能。

## v3.3.1 (2025-10-28)

### 改進

- 更新了 `brainstorming` 技能，要求在詢問之前進行自主偵察，鼓勵推薦驅動的決策，並防止特工將優先級委託給人類。
- 按照斯特倫克的“風格元素”原則，對`brainstorming`技能進行寫作清晰度改進（省略不必要的單詞，將否定形式轉換為肯定形式，改進並行結構）。

### 錯誤修復

- 澄清了 `writing-skills` 指南，使其指向正確的特工特定個人技能目錄（`~/.claude/skills` 用於 Claude Code，`~/.codex/skills` 用於 Codex）。

## v3.3.0 (2025-10-28)

### 新功能

**實驗性法典支持**
- 添加了帶有 bootstrap/use-skill/find-skills 命令的統一 `superpowers-codex` 腳本
- 跨平臺Node.js實現（適用於Windows、macOS、Linux）
- 命名空間技能：`superpowers:skill-name` 為超能力技能，`skill-name` 為個人技能
- 當名字匹配時，個人技能優先於超能力技能
- 乾淨的技能顯示：顯示名稱/描述，沒有原始的前言
- 有用的上下文：顯示每個技能的支持文件目錄
- Codex 的工具映射：TodoWrite→update_plan、子代理→手動後備等。
- 引導程序集成與最小AGENTS.md自動啟動
- 針對 Codex 的完整安裝指南和引導說明

**與 Claude Code 整合的主要區別：**
- 單一統一腳本而不是單獨的工具
- Codex特定等效工具的工具替代系統
- 簡化子代理處理（手動工作而不是委派）
- 更新術語：“超能力技能”而不是“核心技能”

### 文件已添加
- `.codex/INSTALL.md` - Codex 用戶安裝指南
- `.codex/superpowers-bootstrap.md` - 帶有 Codex 改編的引導指令
- `.codex/superpowers-codex` - 具有所有功能的統一 Node.js 可執行文件

**注意：** Codex 支持是實驗性的。該集成提供了核心超級功能，但可能需要根據用戶反饋進行改進。

## v3.2.3 (2025-10-23)

### 改進

**更新了使用超能力技能以使用技能工具而不是閱讀工具**
- 將技能呼叫指令從閱讀工具改為技能工具
- 更新說明：“使用閱讀工具”→“使用技能工具”
- 更新了步驟3：“使用讀取工具”→“使用技能工具讀取並運行”
- 更新合理化清單：“讀取目前版本”→“運行目前版本”

Skill 工具是 Claude Code 中調用技能的正確機制。此更新更正了引導指令，以引導代理使用正確的工具。

### 文件已更改
- 更新：`skills/using-superpowers/SKILL.md` - 將工具參考從“閱讀”更改為“技能”

## v3.2.2 (2025-10-21)

### 改進

**加強使用超能力對抗特工合理化的技巧**
- 添加了極其重要的塊，其中包含關於強制技能檢查的絕對語言
  - “如果某項技能有 1% 的機會適用，你就必須閱讀它”
  - “你別無選擇。你無法合理化自己的出路。”
- 添加了強制性第一響應協議清單
  - 5步流程代理必須在做出任何回應之前完成
  - 明確的“沒有這個響應=失敗”的後果
- 添加了常見合理化部分，其中包含 8 種特定的規避模式
  - “這只是一個簡單的問題”→ 錯誤
  - “我可以快速檢查文件” → 錯誤
  - “讓我先收集信息” → 錯誤
  - 加上在代理行為中觀察到的 5 種更常見的模式

這些變化解決了觀察到的代理行為，儘管有明確的指示，但他們仍圍繞技能使用進行合理化。強有力的語言和先發製人的反駁旨在讓不遵守行為變得更加困難。

### 檔案已更改
- 更新：`skills/using-superpowers/SKILL.md` - 增加了三層強制措施，以防止技能跳過合理化

## v3.2.1 (2025-10-20)

### 新功能

**程式碼審查代理現在包含在插件中**
- 將`superpowers:code-reviewer`代理程式加入外掛程式的`agents/`目錄
- 代理根據計劃和編碼標準提供系統的代碼審查
- 以前要求用戶擁有個人代理配置
- 所有技能參考都更新為使用命名空間`superpowers:code-reviewer`
- 修復 #55

### 檔案已更改
- 新：`agents/code-reviewer.md` - 具有審查清單和輸出格式的代理定義
- 更新：`skills/requesting-code-review/SKILL.md` - 參考`superpowers:code-reviewer`
- 更新：`skills/subagent-driven-development/SKILL.md` - 參考 `superpowers:code-reviewer`

## v3.2.0 (2025-10-18)

### 新功能

**頭腦風暴工作流程中的設計文檔**
- 添加了第 4 階段：設計文檔到頭腦風暴技能
- 設計文檔現在在實施之前寫入`docs/plans/YYYY-MM-DD-<topic>-design.md`
- 恢復技能轉換過程中丟失的原始頭腦風暴命令的功能
- 在工作樹設置和實施規劃之前編寫的文檔
- 使用子代理進行測試，以驗證時間壓力下的合規性

### 重大變化

**技能參考命名空間標準化**
- 所有內部技能引用現在都使用 `superpowers:` 命名空間前綴
- 更新格式：`superpowers:test-driven-development`（之前只是`test-driven-development`）
- 影響所有必需的子技能、推薦的子技能和必需的背景參考
- 與使用技能工具調用技能的方式保持一致
- 更新文件：頭腦風暴、執行計劃、子代理驅動開發、系統調試、子代理測試技能、寫作計劃、寫作技能

### 改進

**設計與實施計劃命名**
- 設計文檔使用`-design.md`後綴來防止文件名衝突
- 實施計劃繼續使用現有的`YYYY-MM-DD-<feature-name>.md`格式
- 兩者都存儲在`docs/plans/`目錄中，具有明確的命名區別

## v3.1.1 (2025-10-17)

### 錯誤修復

- **自述文件中的固定命令語法** (#44) - 更新了所有命令引用以使用正確的命名空間語法（`/superpowers:brainstorm` 而不是 `/brainstorm`）。插件提供的命令由 Claude Code 自動命名，以避免插件之間發生衝突。

## v3.1.0 (2025-10-17)

### 重大變化

**技能名稱標準化為小寫**
- 所有技能 frontmatter `name:` 字段現在使用小寫短橫線匹配目錄名稱
- 示例：`brainstorming`、`test-driven-development`、`using-git-worktrees`
- 所有技能公告和交叉引用均更新為小寫格式
- 這確保了目錄名稱、frontmatter 和文檔之間的命名一致

### 新功能

**增強頭腦風暴技巧**
- 添加了顯示階段、活動和工具使用情況的快速參考表
- 添加了可複制的工作流程清單以跟蹤進度
- 添加了何時重新訪問早期階段的決策流程圖
- 添加了全面的 AskUserQuestion 工具指南和具體示例
- 添加了“問題模式”部分，解釋何時使用結構化問題與開放式問題
- 將關鍵原則重組為可掃描表格

**人類最佳實踐整合**
- 新增了`skills/writing-skills/anthropic-best-practices.md` - 官方人類技能創作指南
- 參考寫作技巧SKILL.md以獲得全面指導
- 提供漸進式揭露、工作流程和評估的模式

### 改進

**技能交叉引用清晰度**
- 所有技能參考現在都使用明確的要求標記：
  - `**REQUIRED BACKGROUND:**` - 您必須瞭解的先決條件
  - `**REQUIRED SUB-SKILL:**` - 工作流程中必須使用的技能
  - `**Complementary skills:**` - 可選但有用的相關技能
- 刪除了舊的路徑格式（`skills/collaboration/X` → 只是`X`）
- 更新了具有分類關係的整合部分（必需與補充）
- 使用最佳實踐更新了交叉引用文檔

**與人擇最佳實踐保持一致**
- 修正了描述語法和語音（完全第三人稱）
- 添加了掃描快速參考表
- 添加了克勞德可以復制和跟蹤的工作流程清單
- 對於不明顯的決策點適當使用流程圖
- 改進的可掃描表格格式
- 所有技能均遠低於 500 行推薦

### 錯誤修復

- **重新添加了缺失的命令重定向** - 恢復了在 v3.0 遷移中意外刪除的 `commands/brainstorm.md` 和 `commands/write-plan.md`
- 修復了`defense-in-depth`名稱不匹配的問題（原為`Defense-in-Depth-Validation`）
- 修復了`receiving-code-review`名稱不匹配的問題（原為`Code-Review-Reception`）
- 修復了 `commands/brainstorm.md` 對正確技能名稱的引用
- 刪除了對不存在的相關技能的引用

### 文件

**寫作技巧的提高**
- 更新了具有明確要求標記的交叉引用指南
- 添加了對 Anthropic 官方最佳實踐的參考
- 改進的示例顯示正確的技能參考格式

## v3.0.1 (2025-10-16)

### 變化

我們現在使用Anthropic的第一方技能係統！

## v2.0.2 (2025-10-12)

### 錯誤修復

- **修正了本機技能儲存庫領先上游時的錯誤警告** - 當本機儲存庫在上游之前提交時，初始化腳本錯誤地警告「上游可用新技能」。現在，邏輯可以正確區分三種 git 狀態：本地落後（應更新）、本地領先（無警告）和發散（應警告）。

## v2.0.1 (2025-10-12)

### 錯誤修復

- **修復了插件上下文中的會話啟動鉤子執行**（#8，PR #9） - 鉤子默默失敗，並出現“插件鉤子錯誤”，阻止加載技能上下文。修復者：
  - 當 Claude Code 的執行上下文中 BASH_SOURCE 未綁定時使用 `${BASH_SOURCE[0]:-$0}` 回退
  - 添加 `|| true` 以在過濾狀態標誌時優雅地處理空 grep 結果

---

# 超能力 v2.0.0 發行說明

＃＃ 概述

Superpowers v2.0 通過重大架構轉變使技能更易於訪問、維護和社區驅動。

主要變化是**技能存儲庫分離**：所有技能、腳本和文件已從插件轉移到專用存儲庫中（[obra/superpowers-skills](https://github.com/obra/superpowers-skills)). 這將超級能力從單一插件轉換為管理技能存儲庫本地克隆的輕量級填充程序。技能在會話啟動時自動更新。用戶通過標準 git 工作庫獨立更新。

除了基礎設施之外，此版本還增加了九項新技能，重點關注問題解決、研究和架構。我們以命令式的語氣和更清晰的結構重寫了核心**使用技能**文檔，使克勞德更容易理解何時以及如何使用技能。 **查找技能** 現在輸出路徑，您可以直接粘貼到讀取工具中，從而消除技能發現工作流程中的摩擦。

使用者體驗無縫操作：插件自動處理克隆、分叉和更新。貢獻者發現新的架構使改進和共享技能變得微不足道。此版本為技能作為社區資源的快速發展奠定了基礎。

## 重大變更

### 技能庫分離

**最大的變化：** 技能不再存在於外掛程式中。它們已被移至位於 [obra/superpowers-skills](https://github.com/obra/superpowers-skills). 的單獨儲存庫

**這對您意味著什麼：**

- **首次安裝：** 外掛程式自動將技能複製到`~/.config/superpowers/skills/`
- **分叉：** 在設定過程中，您將可以選擇分叉技能存儲庫（如果安裝了`gh`）
- **更新：** 技能在會話開始時自動更新（如果可能的話快轉）
- **貢獻：** 在分支上工作，在本地提交，向上遊提交 PR
- **不再有陰影：**舊的兩層系統（個人/核心）被單一儲存庫分支工作流程取代

**遷移：**

如果您有現有安裝：
1. 您的舊`~/.config/superpowers/.git`將會備份到`~/.config/superpowers/.git.bak`
2.舊技能將備份到`~/.config/superpowers/skills.bak`
3. obra/superpowers-skills 的新克隆將在 `~/.config/superpowers/skills/` 創建

### 刪除的功能

- **個人超能力覆蓋系統** - 替換為 git 分支工作流程
- **設定個人超能力掛鉤** - 替換為initialize-skills.sh

## 新功能

### 技能庫基礎設施

**自動克隆和設置** (`lib/initialize-skills.sh`)
- 第一次運行時克隆奧布拉/超能力技能
- 如果安裝了 GitHub CLI，則提供分叉創建
- 正確設置上游/原始遙控器
- 處理從舊安裝的遷移

**自動更新**
- 在每次會話開始時從追蹤遠端獲取
- 可能時自動快轉合併
- 需要手動同步時發出通知（分支分歧）
- 使用從技能存儲庫拉取更新技能進行手動同步

### 新技能

**解決問題的能力** (`skills/problem-solving/`)
- **碰撞區域思維** - 將不相關的概念強行放在一起以獲得緊急見解
- **反演練習** - 翻轉假設以揭示隱藏的約束
- **元模式識別** - 發現跨領域的通用原則
- **規模遊戲** - 進行極端測試以揭示基本事實
- **簡化級聯** - 找到消除多個元件的見解
- **當卡住時** - 分派正確的問題解決技術

**研究技能** (`skills/research/`)
- **追蹤知識血統** - 瞭解想法如何隨著時間的推移而演變

**架構技能** (`skills/architecture/`)
- **保留生產性緊張** - 保留多種有效方法，而不是強迫過早解決

### 技能提升

**使用技能（以前的入門）**
- 從入門更名為使用技能
- 以祈使語氣完全重寫 (v4.0.0)
- 預先加載的關鍵規則
- 為所有工作流程添加了“為什麼”解釋
- 參考文獻中始終包含 /SKILL.md 後綴
- 嚴格的規則和靈活的模式之間的區別更加清晰

**寫作技巧**
- 交叉引用指南從使用技能中移出
- 添加了令牌效率部分（字數目標）
- 改進了 CSO（克勞德搜索優化）指南

**分享技能**
- 更新了新的分支和 PR 工作流程 (v2.0.0)
- 刪除了個人/核心分割引用

**從技能存儲庫中提取更新**（新）
- 與上游同步的完整工作流程
- 取代舊有的「更新技能」技能

### 工具改進

**尋找技能**
- 現在輸出帶有 /SKILL.md 後綴的完整路徑
- 使路徑可以直接使用讀取工具
- 更新了幫助文本

**技能運行**
- 從腳本/移動到技能/使用技能/
- 改進的文檔

### 插件基礎設施

**會話啟動掛鉤**
- 現在從技能存儲庫位置加載
- 在課程開始時顯示完整的技能列表
- 打印技能位置信息
- 顯示更新狀態（更新成功/落後於上游）
- 將“技能落後”警告移至輸出末尾

**環境變數**
- `SUPERPOWERS_SKILLS_ROOT` 設定為 `~/.config/superpowers/skills`
- 在所有路徑中一致使用

## 錯誤修復

- 修復了分叉時重複的上游遠程添加
- 修復了輸出中的查找技能雙“技能/”前綴
- 從會話開始中刪除了過時的 setup-personal-superpowers 調用
- 修復了整個鉤子和命令的路徑引用

## 文件

### 自述文件
- 更新了新的技能儲存庫架構
- 超級大國技能存儲庫的顯著鏈接
- 更新了自動更新說明
- 修復了技能名稱和參考
- 更新了元技能列表

### 測試文檔
- 新增了全面的測試清單（`docs/TESTING-CHECKLIST.md`）
- 建立本地市場配置以進行測試
- 記錄手動測試場景

## 技術細節

### 文件更改

**添加：**
- `lib/initialize-skills.sh` - 技能庫初始化和自動更新
- `docs/TESTING-CHECKLIST.md` - 手動測試場景
- `.claude-plugin/marketplace.json` - 本地測試配置

**刪除：**
- `skills/` 目錄（82 個文件） - 現在位於 obra/superpowers-skills
- `scripts/` 目錄 - 現在位於 obra/superpowers-skills/skills/using-skills/
- `hooks/setup-personal-superpowers.sh` - 已過時

**修改：**
- `hooks/session-start.sh` - 使用 ~/.config/superpowers/skills 中的技能
- `commands/brainstorm.md` - 更新了 SUPERPOWERS_SKILLS_ROOT 的路徑
- `commands/write-plan.md` - 更新了 SUPERPOWERS_SKILLS_ROOT 的路徑
- `commands/execute-plan.md` - 更新了 SUPERPOWERS_SKILLS_ROOT 的路徑
- `README.md` - 新架構的完全重寫

### 提交歷史記錄

此版本包括：
- 20 多項技能庫分離提交
- PR #1：放大器啟發的問題解決和研究技能
- PR#2：個人超能力疊加系統（後被替換）
- 多項技能改進和文檔改進

## 升級說明

### 全新安裝

```bash
# In Claude Code
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

該插件會自動處理一切。

### 從v1.x 升級

1. **備份你的個人技能**（如果有的話）：```bash
   cp -r ~/.config/superpowers/skills ~/superpowers-skills-backup
   ```

2. **更新插件：**```bash
   /plugin update superpowers
   ```

3. **下次會議開始時：**
   - 舊安裝將自動備份
   - 新技能庫將被克隆
   - 如果您有 GitHub CLI，您將可以選擇分叉

4. **遷移個人技能**（如果您有的話）：
   - 在您的本機技能儲存庫中建立一個分支
   - 從備份複製您的個人技能
   - 提交並推送到你的分叉
   - 考慮透過公關做出貢獻

## 下一步是什麼

### 對於用戶

- 探索新的解決問題的技巧
- 嘗試基於分支的工作流程來提高技能
- 為社區貢獻技能

### 對於貢獻者

- 技能存儲庫現在位於https://github.com/obra/superpowers-skills
- 分叉 → 分支 → PR 工作流程
- 請參閱 skills/meta/writing-skills/SKILL.md 瞭解 TDD 文檔方法

## 已知問題

目前沒有。

## 學分

- 受放大器模式啟發的解決問題技能
- 社區貢獻和反饋
- 技能有效性的廣泛測試和迭代

---

**完整變更日誌：** https://github.com/obra/superpowers/compare/dd013f6...main
**技能庫：** https://github.com/obra/superpowers-skills
**問題：** https://github.com/obra/superpowers/issues
