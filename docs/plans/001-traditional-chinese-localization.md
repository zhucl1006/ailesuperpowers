# Superpowers 全量繁體中文化實施計畫

> **給 Claude：** 必需子技能：使用 `project-workflow` 逐任務執行本計畫。

**建立時間：** 2026-02-12  
**狀態：** 已完成  
**負責人：** Codex

**目標：** 將目前工程中的使用者可見內容全面繁體中文化（含歷史計畫文件），並完成回歸驗證。  
**架構：** 採用「先規範、再分層翻譯、最後回歸」策略；本次採 **全量繁體中文**，不保留英文觸發文案。  
**技術棧：** Markdown、Shell、Node.js、既有測試腳本。

---

## 整體進度

- 總體進度：100%
- 當前階段：Phase 6（收尾與交付）
- 下一里程碑：已完成

## 任務狀態總覽

| 任務 | 名稱 | 狀態 | 負責人 | 依賴 |
|---|---|---|---|---|
| 1 | 建立繁體中文化規範與術語 | 已完成 | Codex | 無 |
| 2 | 全量翻譯根文檔與安裝文檔 | 已完成 | Codex | 1 |
| 3 | 全量翻譯 docs 主體與歷史 plans | 已完成 | Codex | 1,2 |
| 4 | 全量翻譯 skills 與配套說明 | 已完成 | Codex | 1 |
| 5 | 全量翻譯命令與代理提示文檔 | 已完成 | Codex | 1,4 |
| 6 | 全量翻譯執行時注入文案（hook/plugin） | 已完成 | Codex | 1,4 |
| 7 | 調整測試基線與語系相關斷言 | 已完成 | Codex | 2,3,4,5,6 |
| 8 | 全量回歸、發布說明繁體化與驗收 | 已完成 | Codex | 7 |

## 執行記錄

| 日期 | 任務 | 操作 | 結果 | 備註 |
|---|---|---|---|---|
| 2026-02-12 | 初始化 | 建立計畫文件 | 完成 | 開始執行 |
| 2026-02-12 | 1-6 | 完成文檔、技能、命令、安裝文檔與注入文案繁體化 | 完成 | 已做 OpenCC 全量繁轉 |
| 2026-02-12 | 7 | 執行測試基線檢查（OpenCode / skill-triggering / explicit-skill-requests） | 完成 | 已修復測試腳本與提示詞回歸 |
| 2026-02-12 | 8 | 完成全量回歸與交付收尾 | 完成 | 三套關鍵測試通過，臨時腳本已清理 |
| 2026-02-12 | 8（附加驗收） | 補跑 `tests/claude-code/run-skill-tests.sh --timeout 900` 並修復繁中場景不穩定斷言 | 完成 | 測試最終 PASSED（1 passed, 0 failed） |

---

## 範圍與驗收標準

### 範圍（全量繁體）

- 必須繁體化：
  - 根文檔與安裝文檔：`README.md`、`RELEASE-NOTES.md`、`.codex/INSTALL.md`、`.opencode/INSTALL.md`
  - 全部文檔文檔（含`docs/plans/*.md` 歷史計畫）
  - 全部技能文件與作業說明（`skills/**/*.md`）
  - 命令與代理提示文檔（`commands/*.md`、`agents/*.md`）
  - 執行時可見提示文本（`hooks/session-start.sh`、`.opencode/plugins/superpowers.js`）
  - 測試中的可見文案與斷言文本（必要時）

- 不翻譯：
  - 程序碼識別符、命令參數、路徑、hash、JSON按鍵名、函式名
  - 前題的`name` 鍵值（避免技能命名失效）

### 驗收標準

1. 使用者可見自然語言內容為繁體中文。
2. 文件結構、連結、程式碼區塊與指令可正常使用。
3. 主要測試腳本可運行，至少透過 OpenCode 和技能觸發套件。
4. `RELEASE-NOTES.md` 全文繁體中文。

---

## 任務清單（寫作計劃模式）

### 任務 1：建立繁體中文化規範與術語

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 建立：`docs/i18n/README.md`
- 建立：`docs/i18n/terminology-zh-Hant.md`
- 建立：`docs/i18n/translation-rules.md`

**步驟 1：建立驗收規則與禁改清單**

- 明確哪些內容可翻、不可翻（程式碼鍵值/路徑/命令）。

**步驟 2：建立術語表**

- 統一關鍵字翻譯（如skill、hook、bootstrap、worktree、subagent）。

**步驟 3：快速檢查**

```bash
rg -n "TODO|待補充|待定" "docs/i18n"
```

---

### 任務 2：全量翻譯根文檔與安裝文檔

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`README.md`
- 修改：`RELEASE-NOTES.md`
- 修改：`docs/README.codex.md`
- 修改：`docs/README.opencode.md`
- 修改：`.codex/INSTALL.md`
- 修改：`.opencode/INSTALL.md`

**步驟 1：翻譯自然語言段落**

- 保留命令塊與鏈接URL不變。

**步驟 2：翻譯標題/列表/說明文字**

- 避免破壞 Markdown 結構。

**步驟 3：鏈接檢查**

```bash
rg -n "\]\([^)]*\)" "README.md" "docs/README.codex.md" "docs/README.opencode.md"
```

---

### 任務3：全量翻譯文檔主體與歷史計劃

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`docs/**/*.md`（含 `docs/plans/*.md`）

**步驟1：分批翻譯文檔**

- 優先 `specs/guides/modules/api/database`，再翻譯 `plans/testing/windows`。

**步驟 2：結構一致性檢查**

```bash
rg -n "```|^#|^\- |^\* " "docs" >/dev/null
```

**步驟 3：佔位詞檢查**

```bash
rg -n "\bTODO\b|\bTBD\b" "docs"
```

---

### 任務4：全量翻譯技能及配套說明

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`skills/*/SKILL.md`
- 修改：`skills/**/*.md`

**步驟1：保護frontmatter關鍵字段**

- `name` 值不改。
- `description` 翻譯為繁體中文。

**步驟 2：翻譯正文**

- 全文繁體；命令與路徑保持原樣。

**步驟3：frontmatter驗證**

```bash
for f in skills/*/SKILL.md; do sed -n "1,8p" "$f"; done
```

---

### 任務 5：全量翻譯命令與代理提示文檔

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`commands/brainstorm.md`
- 修改：`commands/write-plan.md`
- 修改：`commands/execute-plan.md`
- 修改：`agents/code-reviewer.md`
- 修改：`skills/requesting-code-review/code-reviewer.md`

**步驟 1：翻譯可見文字與規則說明**

**步驟 2：保留命令語義與路徑引用**

**步驟 3：關鍵規則快速掃描**

```bash
rg -n "MUST|DO NOT|Critical|重要|必須" "commands" "agents" "skills/requesting-code-review"
```

---

### 任務 6：全量翻譯執行時注入文案（hook/plugin）

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`hooks/session-start.sh`
- 修改：`.opencode/plugins/superpowers.js`

**步驟 1：翻譯使用者可見字串與註解**

**步驟2：驗證hook JSON結構**

```bash
bash "hooks/session-start.sh" | jq . >/dev/null
```

**步驟3：驗證JS語法**

```bash
node --check ".opencode/plugins/superpowers.js"
```

---

### 任務 7：調整測試基線與語系相關斷言

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`tests/claude-code/*.sh`
- 修改：`tests/skill-triggering/*.sh`
- 修改：`tests/explicit-skill-requests/*.sh`
- 修改：`tests/opencode/*.sh`

**步驟 1：替換英文固定文案斷言（必要時）**

**步驟 2：保留行為型斷言（觸發/順序/結果）**

**步驟 3：執行關鍵測試**

```bash
bash "tests/opencode/run-tests.sh"
bash "tests/skill-triggering/run-all.sh"
bash "tests/explicit-skill-requests/run-all.sh"
```

---

### 任務 8：全量回歸、發布說明繁體化與驗收

**狀態:** 待開始  
**負責人:** 待定  
**開始時間:** 待定  
**完成時間:** 待定  
**阻塞原因:** 無

**文件：**

- 修改：`RELEASE-NOTES.md`
- 修改：`docs/README.md`（補充語系維護策略）

**步驟 1：回歸執行**

```bash
bash "tests/opencode/run-tests.sh"
bash "tests/skill-triggering/run-all.sh"
bash "tests/explicit-skill-requests/run-all.sh"
```

**步驟 2：完成驗收清單**

- 範圍、品質、可執行性與可維護性全數勾選。

**步驟 3：更新發布說明**

- 將本次繁體中文化內容、相容性風險與回退策略寫入 `RELEASE-NOTES.md`。

---

## 風險與緩解

1. **技能觸發回歸風險**：`description` 全繁體後可能影響舊習慣觸發。  
   - 緩解：加強觸發測試並調整關鍵提示詞。  
2. **翻譯造成格式破壞**：可能破壞frontmatter、程序代碼塊、link。
   - 緩解：翻譯流程中加入格式保護與結構驗證。  
3. **測試斷言語系耦合**：原斷言依賴英文句子。  
   - 緩解：改為行為與結構導向斷言。

## 已確認決策

1. 採用 **全量繁體中文**（非兼容優先）。  
2. `docs/plans/` 歷史計畫文件 **納入繁體化**。  
3. `RELEASE-NOTES.md` 採 **全文繁體中文**。
