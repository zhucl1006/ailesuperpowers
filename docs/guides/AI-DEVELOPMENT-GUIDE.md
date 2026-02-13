# 人工智慧開發指南

本指南定義了安全發展超級大國的預設工程工作流程。

## 一、工作原理

- 保持變更最少且明確（KISS、YAGNI）
- 在引入新抽象之前重用現有模式（DRY）
- 保留模組邊界（`skills`, `integration`, `shared core`, `tests`)
- 在聲明完成之前使用可運行的證據驗證行為

## 2. 存儲庫約定

### 2.1 技能文件約定

- 每項技能都存在於`skills/<skill-name>/SKILL.md`
- 目前核心解析中使用的 Frontmatter 鍵：
  - `name`
  - `description`
- 支持文件應位於同一目錄中的技能旁邊

### 2.2 腳本約定

- shell腳本應該使用`set -euo pipefail`適用時
- 偏好可移植的 shell 語法和引用路徑/變量
- 保持腳本可組合且單一用途

### 2.3 文檔約定

- 影響架構的變更必須更新`docs/specs/SAD.md`
- 影響工作流程的變更必須更新本指南
- 將面向發布的遷移註釋保留在`RELEASE-NOTES.md`

## 3. 推薦的開發流程

1. 澄清範圍和受影響的模塊
2. 首先閱讀現有的實作和測試
3. 實施最小的可行改變
4. 更新/添加更改行為的測試
5. 運行相關測試套件
6. 更新受更改影響的文檔

## 4.改變劇本

### 4.1 添加或更新技能

1. 編輯`skills/<name>/SKILL.md`
2. 如果新增的支援資產，請將它們放在同一技能目錄下
3. 運行與該技能相關的觸發器檢查：
   - `tests/skill-triggering/run-test.sh`（或者`run-all.sh`)
   - `tests/explicit-skill-requests/run-test.sh`對於顯式呼叫行為
4. 如果工作流程語意發生更改，請更新：
   - `docs/specs/PRD.md`
   - `docs/modules/skills-library.md`

### 4.2 更新 OpenCode 集成

1. 編輯`.opencode/plugins/superpowers.js`和/或`.opencode/INSTALL.md`
2. 跑步：
   - `tests/opencode/run-tests.sh`
   - 可選地`tests/opencode/run-tests.sh --integration`
3. 更新：
   - `docs/README.opencode.md`
   - `docs/modules/platform-integration.md`

### 4.3 更新 Claude hook/bootstrap 行為

1. 編輯`hooks/hooks.json`和/或`hooks/session-start.sh`
2. 驗證 shell 行為和上下文負載格式
3. 在下運行相關的克勞德端測試`tests/claude-code/`
4. 更新`docs/modules/hooks-and-bootstrap.md`

### 4.4 更新共享核心庫

1. 編輯`lib/skills-core.js`
2. 運行 OpenCode 測試套件：
   - `tests/opencode/run-tests.sh`
3. 重新驗證文檔/API 規格和模組文檔中的技能解析假設

## 5. 驗證矩陣

選擇最小的充分驗證集：

- **技能觸發語義：**
  - `tests/skill-triggering/run-all.sh`
  - `tests/explicit-skill-requests/run-all.sh`
- **克勞德代碼工作流程行為：**
  - `tests/claude-code/run-skill-tests.sh`
- **OpenCode 外掛行為：**
  - `tests/opencode/run-tests.sh`
- **子代理驅動的端對端線束：**
  - `tests/subagent-driven-dev/run-test.sh <test-name>`

## 6. 完成清單

標記完成之前：

- [ ] 滿足要求且沒有範圍蔓延
- [ ] 通過相關測試（或明確記錄為什麼不運行）
- [ ] 受影響的文檔已更新
- [ ] 沒有對已刪除的安裝/運行時流程的陳舊引用
- [ ] 明確記錄的風險/限制

## 7. 常見陷阱

- 僅從命令狀態聲明成功，而不驗證預期行為
- 編輯整合行為而不更新安裝和遷移文檔
- 增加重複現有技能/流程機制的新模式
- 當程式碼提供具體證據時，將文件保留為推斷假設
