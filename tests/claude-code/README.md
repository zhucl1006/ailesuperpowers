# 克勞德程式碼技能測試

使用 Claude Code CLI 自動測試超能力技能。

## 概述

該測試套件驗證技能是否正確加載，並且 Claude 按預期遵循它們。測試在無頭模式下調用克勞德代碼（`claude -p`）並驗證行為。

## 要求

- Claude Code CLI 已安裝並位於 PATH 中（`claude --version`應該有效）
- 安裝本地超級大國插件（安裝請參閱主要自述文件）

## 運行測試

### 運行所有快速測試（推薦）：
```bash
./run-skill-tests.sh
```

### 運行集成測試（緩慢，10-30 分鐘）：
```bash
./run-skill-tests.sh --integration
```

### 運行具體測試：
```bash
./run-skill-tests.sh --test test-subagent-driven-development.sh
```

### 以詳細輸出運作：
```bash
./run-skill-tests.sh --verbose
```

### 設定自訂逾時：
```bash
./run-skill-tests.sh --timeout 1800  # 30 minutes for integration tests
```

## 測試結構

### test-helpers.sh
技能測試常用功能：
- `run_claude "prompt" [timeout]`- 根據提示運行克勞德
- `assert_contains output pattern name`- 驗證模式是否存在
- `assert_not_contains output pattern name`- 驗證模式不存在
- `assert_count output pattern count name`- 驗證準確計數
- `assert_order output pattern_a pattern_b name`- 驗證訂單
- `create_test_project`- 建立暫存測試目錄
- `create_test_plan project_dir`- 建立範例規劃文件

### 測試文件

每個測試文件：
1. 來源`test-helpers.sh`
2. 使用特定提示運行 Claude Code
3. 使用斷言驗證預期行為
4. 成功時回傳 0，失敗時回傳非零

## 測試示例

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: My Skill ==="

# Ask Claude about the skill
output=$(run_claude "What does the my-skill skill do?" 30)

# Verify response
assert_contains "$output" "expected behavior" "Skill describes behavior"

echo "=== All tests passed ==="
```

## 當前測試

### 快速測試（預設運行）

#### test-subagent-driven-development.sh
測試技能內容和要求（約 2 分鐘）：
- 技能負載和可訪問性
- 工作流程排序（規範合規性優先於代碼質量）
- 記錄自我審查要求
- 記錄計劃閱讀效率
- 規範合規審查員的懷疑記錄在案
- 審查記錄的循環
- 記錄任務情境規定

### 整合測試（使用--integration標誌）

#### test-subagent-driven-development-integration.sh
完整工作流程執行測試（約 10-30 分鐘）：
- 使用 Node.js 設定建立真實的測試項目
- 建立包含 2 項任務的實施計劃
- 使用子代理驅動開發執行計劃
- 驗證實際行為：
  - 計劃在開始時閱讀一次（不是每個任務）
  - 子代理提示中提供完整的任務文本
  - 下級代理在報告前進行自我審查
  - 規範合規性審查發生在代碼質量之前
  - 規範審閱者獨立閱讀代碼
  - 工作實施已產生
  - 測試通過
  - 建立正確的 git 提交

**測試什麼：**
- 工作流程實際上是端到端的
- 我們的改進已實際應用
- 子代理正確遵循技能
- 最終程式碼可以正常運作並經過測試

## 添加新測試

1. 創建新的測試文件：`test-<skill-name>.sh`
2. 來源test-helpers.sh
3. 使用編寫測試`run_claude`和斷言
4. 新增到測試清單中`run-skill-tests.sh`
5. 使可執行：`chmod +x test-<skill-name>.sh`

## 超時注意事項

- 預設逾時：每次測試 5 分鐘
- 克勞德·科德 可能需要一些時間才能回覆
- 調整為`--timeout`如果需要的話
- 測試應集中於避免長時間運行

## 調試失敗的測試

和`--verbose`，您將看到完整的克勞德輸出：
```bash
./run-skill-tests.sh --verbose --test test-subagent-driven-development.sh
```

如果沒有詳細訊息，則僅顯示失敗的輸出。

## 持續集成/持續交付集成

在 CI 中運行：
```bash
# Run with explicit timeout for CI environments
./run-skill-tests.sh --timeout 900

# Exit code 0 = success, non-zero = failure
```

## 筆記

- 測試驗證技能*指令*，而不是完全執行
- 完整的工作流程測試會非常慢
- 專注於驗證關鍵技能要求
- 測試應該是確定性的
- 避免測試實作細節
