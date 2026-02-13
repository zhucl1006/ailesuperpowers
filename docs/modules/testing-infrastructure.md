# 模組：測試基礎設施

## 1.範圍

- 小路：`tests/`
- 目的：驗證技能觸發、平臺集成和工作流程的正確性

## 2. 測試層

### A 層：觸發級行為

- `tests/skill-triggering/`
- 根據自然語言提示驗證技能激活（沒有明確的技能名稱）

### B 層：明確請求行為

- `tests/explicit-skill-requests/`
- 驗證直接用戶請求（e.g.，“使用 X 技能”）是否實際調用目標技能

### C 層：Claude 整合行為

- `tests/claude-code/`
- 透過 Claude CLI 執行和轉錄分析驗證行為

### D 層：OpenCode 集成行為

- `tests/opencode/`
- 驗證外掛程式載入、核心庫行為和技能優先權解析

### E層：場景線束

- `tests/subagent-driven-dev/`
- 提供更高層級的端對端任務場景和輸出工件捕獲

## 3. 工具假設

- 外殼環境與`bash`
- `claude`用於以 Claude 為中心的測試的 CLI
- `opencode`用於 OpenCode 整合測試的 CLI
- 可選助手：`jq`, `timeout`, `node`, `python3`

## 4. 可靠性實踐

- 測試使用獨立的臨時目錄來存放固定裝置
- 集成測試有明確的超時
- 腳本發出通過/失敗標記並儲存診斷日誌

## 5. 已知限制

- 並非所有套件都在純離線環境中運行
- 平臺二進位（`claude`, `opencode`) 是外部先決條件
- 存儲庫中還沒有統一的 CI 管道文件

## 6. 推薦執行順序

1. `tests/opencode/run-tests.sh`
2. `tests/skill-triggering/run-all.sh`
3. `tests/explicit-skill-requests/run-all.sh`
4. `tests/claude-code/run-skill-tests.sh`
5. 可選的長期場景`tests/subagent-driven-dev/`
