# 超能力文檔索引

該目錄包含 Superpowers 專案的產品、架構、模組和操作文件。

## 為什麼存在這個文檔

該文檔集的維護主要是為了支持後續開發工作、跨平臺維護以及貢獻者入職培訓。

## 文件圖

### 產品與架構

- `docs/specs/PRD.md`- 產品目標、使用者價值、功能和非功能需求（從當前程式碼和發布歷史記錄中回填）
- `docs/specs/SAD.md`- 軟體架構設計和技術決策（從儲存庫實作中回填）

### 工程指南

- `docs/guides/AI-DEVELOPMENT-GUIDE.md`- 日常開發工作流程、編碼約定、驗證清單

### 團隊模板（Aile）

- `docs/templates/`- 階段產物模板（Story/分析計畫/PR 描述）
- `docs/templates/g2-design-review-checklist.md`- G2 設計審查清單（PM/QA/開發負責人協作門禁）
- `docs/modules/aile-skill-mapping.md`- 團隊自定義 `aile-*` Skill 與原 Skill 的映射與增強點
- `docs/guides/JIRA-MCP-INTEGRATION.md`- Jira MCP 整合指南（工具契約、環境變數與安全約束）
- `docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md`- Google Drive 同步指南（產品路由、歷史版本策略、權限失敗兜底）
- `docs/plans/PILOT-STORY-REPORT.md`- Aile 工作流試點報告模板（端到端演練記錄）

### 模組文檔

- `docs/modules/skills-library.md`- 技能分類、結構和擴展規則
- `docs/modules/platform-integration.md`- Claude Code、Codex、OpenCode 整合模型
- `docs/modules/skills-core-library.md` - `lib/skills-core.js`內部庫 API 和行為
- `docs/modules/hooks-and-bootstrap.md`- 會話引導和鉤子機制
- `docs/modules/testing-infrastructure.md`- 測試層、腳本和執行策略

### 應用程式介面和數據

- `docs/api/api-spec.md`- 內部API合約（庫匯出、外掛程式合約、命令合約）
- `docs/database/SCHEMA.md`- 持久數據模型（基於文件系統；無關係數據庫）
- `docs/database/MIGRATIONS.md`- 儲存與結構遷移歷史

### 現有的操作和歷史文檔

- `docs/testing.md`- Claude Code 集成測試指南
- `docs/windows/polyglot-hooks.md`- Windows鉤子兼容性背景
- `docs/README.codex.md`- Codex安裝和使用
- `docs/README.opencode.md`- OpenCode安裝和使用
- `docs/plans/*.md`- 實施計劃和提案記錄

## 推薦閱讀順序

1. `docs/specs/PRD.md`
2. `docs/specs/SAD.md`
3. `docs/guides/AI-DEVELOPMENT-GUIDE.md`
4. 模組文檔位於`docs/modules/`
5. 特定於平臺的文檔（`docs/README.codex.md`, `docs/README.opencode.md`)

## 維修政策

- 保持文件與儲存庫行為保持一致；執行是真理的來源。
- 當改變架構時，更新`docs/specs/SAD.md`以及同一 PR 中受影響的模塊文檔。
- 更改貢獻者工作流程時，請更新`docs/guides/AI-DEVELOPMENT-GUIDE.md`.
- 更改安裝/分發行為時，更新平臺文件和`docs/modules/platform-integration.md`.
