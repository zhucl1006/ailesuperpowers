# 產品需求文件（PRD）

## 1. 文檔元數據

- 項目：超能力
- 文檔類型：PRD（從代碼回填）
- 版本：1.0
- 狀態：草案（需要未來業務端完善）
- 最後更新: 2026-02-12

## 2、資訊來源

- **代碼派生**：`skills/`, `commands/`, `hooks/`, `.opencode/`, `.codex/`, `.claude-plugin/`, `lib/`, `tests/`
- **回購文檔**：`README.md`, `RELEASE-NOTES.md`, `docs/README.codex.md`, `docs/README.opencode.md`, `docs/testing.md`
- **使用者提供**：本文檔用於後續開發工作
- **推斷**：從當前架構和發布策略推斷出的產品語言和優先級

## 3、產品概述

Superpowers 是一個用於編碼代理的可重用技能庫和工作流程框架。它提供：

1. 策劃的開發技能（規劃、TDD、調試、審查、工作流程編排）
2. Claude Code、Codex 和 OpenCode 的平臺特定集成
3. 測試基礎設施，驗證技能觸發、執行行為和整合可靠性

## 4. 目標和非目標

### 4.1目標

- 通過技能提供一致、高質量的工程工作流程
- 確保技能在受支持的代理平臺上可發現和使用
- 減少臨時編碼代理行為所引起的故障模式
- 通過可維護的文檔和測試覆蓋率支持未來的功能開發

### 4.2 非目標

- 不是具有最終用戶 UI 工作流程的業務應用程式
- 不是託管 SaaS 平臺
- 不能取代平臺本機安全/權限模型

## 5.目標用戶

### 主要用戶

- 使用 Claude Code、Codex 或 OpenCode 的 AI 輔助軟體工程師
- 維護者擴展或完善超能力技能

### 二級用戶

- 團隊標準化程式碼產生工作流程和審查標準
- 貢獻者添加新技能和平臺兼容性改進

## 6. 核心價值主張

- **一致性**：規劃、編碼、審查和驗證的標準化工作流程
- **可靠性**：透過面向驗證的技能減少錯誤的成功聲明
- **可移植性**：跨多個編碼代理生態系統的一套技能
- **可擴展性**：個人/項目技能可以與核心技能共存

## 七、功能要求

|身份證 |要求|狀態 |證據|
|---|---|---|---|
| FR-001 |技能必須是可發現的`SKILL.md`帶有 frontmatter 元數據的單元 |已實施 |`skills/*/SKILL.md`, `lib/skills-core.js` |
| FR-002 |必須支援核心工作流程技能（需求接入→計畫→執行→審查）|已實施 |`skills/aile-requirement-analysis/SKILL.md`, `skills/aile-writing-plans/SKILL.md`, `skills/aile-subagent-dev/SKILL.md`, `skills/aile-code-review/SKILL.md` |
| FR-003 | Claude 代碼集成必須在會話開始時注入引導上下文 |已實施 |`hooks/hooks.json`, `hooks/session-start.sh` |
| FR-004 | Codex 設置必須支持通過文件系統鏈接發現本機技能 |已實施 |`.codex/INSTALL.md`, `docs/README.codex.md` |
| FR-005 | OpenCode 外掛程式必須透過系統轉換注入使用超能力指導 |已實作 |`.opencode/plugins/superpowers.js` |
| FR-006 |技能解析必須支持影子規則 |已實施 |`lib/skills-core.js`, `tests/opencode/test-priority.sh` |
| FR-007 |測試必須涵蓋類別單元行為和整合行為 |已實施 |`tests/opencode/*`, `tests/claude-code/*`, `tests/skill-triggering/*`, `tests/explicit-skill-requests/*` |
| FR-008 |計劃工件必須可存儲在存儲庫文檔中 |已實施 |`docs/plans/*.md` |

## 8. 非功能性需求

### NFR-001 跨平臺兼容性

- 必須在 macOS/Linux/Windows 上運行才能進行安裝和核心引導流程
- 證據：發行說明和 Windows 特定文檔（`RELEASE-NOTES.md`, `docs/windows/polyglot-hooks.md`)

### NFR-002 可維護性

- 技能和整合邏輯應該模組化且可獨立編輯
- 證據：分裂`skills/`, `lib/`, `hooks/`, `.opencode/`, `commands/`

### NFR-003 可觀察性/驗證

- 主要行為應該可以通過可運行的腳本來驗證，而不僅僅是手動檢查
- 證據：可運行的測試套件`tests/`

### NFR-004 向後感知演化

- 文件和發行說明應擷取重大變更和遷移路徑
- 證據：`RELEASE-NOTES.md`,安裝文檔

## 9. 當前階段和路線圖

### 現階段

- 成熟的開源工作流程工具包，目前正在優化以供後續持續開發

### 近期優先事項（來自最近的計劃和發布方向）

1. 根據生產回饋提高技能品質（`docs/plans/2025-11-28-skills-improvements-from-user-feedback.md`)
2. 繼續跨平臺可靠性強化（特別是Windows邊緣情況）
3. 加強子代理工作流程的審查/測試護欄

## 10. 成功指標

### 產品指標

- 對於所需的工作流程技能，技能觸發測試保持綠色
- 發布後引導/安裝路徑中報告的回歸更少
- 減少工作流程實踐中的誤報完成聲明（定性）

### 工程指標

- 每個版本的文檔和程式碼保持一致
- 關鍵整合測試在支援的環境中傳遞

## 11、風險和限制

- 對外部代理平臺行為的依賴（API/工具語意可能會改變）
- 跨平臺 shell/工具差異可能會導致回歸
- 技能質量取決於及時的清晰度和嚴格的使用

## 12. 需要未來業務澄清的未清項目

- 正式的用戶細分和採用目標
- 類似 SLA 的量化品質目標（故障率、週轉時間、成本）
- 超出當前追蹤計畫的明確的長期功能路線圖
