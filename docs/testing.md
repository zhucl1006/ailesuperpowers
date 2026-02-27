# 測試超能力技能

本文檔描述如何測試超級技能，特別是複雜技能的整合測試，例如`aile-subagent-dev`.

## 概述

測試涉及子代理程式、工作流程和複雜互動的技能需要在無頭模式下運行實際的 Claude Code 會話，並透過會話記錄驗證其行為。

## 測試結構

```
tests/
├── claude-code/
│   ├── test-helpers.sh                    # Shared test utilities
│   ├── test-aile-subagent-dev-integration.sh
│   ├── analyze-token-usage.py             # Token analysis tool
│   └── run-skill-tests.sh                 # Test runner (if exists)
```

## 運行測試

### 集成測試

整合測試使用實際技能執行真實的克勞德程式碼會話：

```bash
# Run the aile-subagent-dev integration test
cd tests/claude-code
./test-aile-subagent-dev-integration.sh
```

**注意：** 整合測試可能需要 10-30 分鐘，因為它們使用多個子代理執行實際實施計劃。

### 要求

- 必須從 **superpowers 插件目錄** 運行（而不是從臨時目錄）
- 克勞德代碼必須安裝並可用`claude`命令
- 必須啟用本地開發市場：`"superpowers@superpowers-dev": true`在`~/.claude/settings.json`

## 集成測試：子代​​理驅動開發

### 它測試什麼

集成測試驗證了`aile-subagent-dev`技能正確：

1. **計劃加載**：開始時閱讀一次計劃
2. **完整任務文本**：向子代理提供完整的任務描述（不會讓他們讀取文件）
3. **自我審查**：確保子代理在報告前進行自我審查
4. **審核順序**：在程式碼品質審核之前執行規範合規性審核
5. **審查循環**：發現問題時使用審查循環
6. **獨立驗證**：規範審查者獨立讀取代碼，不信任實施者報告

### 它是如何運作的

1. **設定**：建立一個臨時Node.js項目，並制定最小的實施計劃
2. **執行**：使用技能在無頭模式下運行克勞德程式碼
3. **驗證**：解析會話記錄（`.jsonl`文件）來驗證：
   - 技能工具被調用
   - 已派遣子代理程式（任務工具）
   - TodoWrite 用於跟蹤
   - 建立實施文件
   - 測試通過
   - Git 提交顯示正確的工作流程
4. **令牌分析**：按子代理顯示令牌使用情況細分

### 測試輸出

```
========================================
 Integration Test: aile-subagent-dev
========================================

Test project: /tmp/tmp.xyz123

=== Verification Tests ===

Test 1: Skill tool invoked...
  [PASS] aile-subagent-dev skill was invoked

Test 2: Subagents dispatched...
  [PASS] 7 subagents dispatched

Test 3: Task tracking...
  [PASS] TodoWrite used 5 time(s)

Test 6: Implementation verification...
  [PASS] src/math.js created
  [PASS] add function exists
  [PASS] multiply function exists
  [PASS] test/math.test.js created
  [PASS] Tests pass

Test 7: Git commit history...
  [PASS] Multiple commits created (3 total)

Test 8: No extra features added...
  [PASS] No extra features added

=========================================
 Token Usage Analysis
=========================================

Usage Breakdown:
----------------------------------------------------------------------------------------------------
Agent           Description                          Msgs      Input     Output      Cache     Cost
----------------------------------------------------------------------------------------------------
main            Main session (coordinator)             34         27      3,996  1,213,703 $   4.09
3380c209        implementing Task 1: Create Add Function     1          2        787     24,989 $   0.09
34b00fde        implementing Task 2: Create Multiply Function     1          4        644     25,114 $   0.09
3801a732        reviewing whether an implementation matches...   1          5        703     25,742 $   0.09
4c142934        doing a final code review...                    1          6        854     25,319 $   0.09
5f017a42        a code reviewer. Review Task 2...               1          6        504     22,949 $   0.08
a6b7fbe4        a code reviewer. Review Task 1...               1          6        515     22,534 $   0.08
f15837c0        reviewing whether an implementation matches...   1          6        416     22,485 $   0.07
----------------------------------------------------------------------------------------------------

TOTALS:
  Total messages:         41
  Input tokens:           62
  Output tokens:          8,419
  Cache creation tokens:  132,742
  Cache read tokens:      1,382,835

  Total input (incl cache): 1,515,639
  Total tokens:             1,524,058

  Estimated cost: $4.67
  (at $3/$15 per M tokens for input/output)

========================================
 Test Summary
========================================

STATUS: PASSED
```

## 代幣分析工具

### 用法

分析任何 Claude Code 會話中的令牌使用情況：

```bash
python3 tests/claude-code/analyze-token-usage.py ~/.claude/projects/<project-dir>/<session-id>.jsonl
```

### 查找會話文件

會話記錄儲存在`~/.claude/projects/`工作目錄路徑編碼：

```bash
# Example for /Users/jesse/Documents/GitHub/superpowers/superpowers
SESSION_DIR="$HOME/.claude/projects/-Users-jesse-Documents-GitHub-superpowers-superpowers"

# Find recent sessions
ls -lt "$SESSION_DIR"/*.jsonl | head -5
```

### 它顯示了什麼

- **主會話使用**：協調者（您或主 Claude 實例）的令牌使用情況
- **每個子代理細分**：每個任務調用：
  - 代理 ID
  - 描述（摘自提示）
  - 訊息數
  - 輸入/輸出令牌
  - 快取使用情況
  - 預計費用
- **總計**：整體代幣使用量與成本估算

### 瞭解輸出

- **高快取讀取**：良好 - 表示提示快取正在工作
- **主節點上的高輸入令牌**：預期 - 協調器具有完整的上下文
- **每個子代理的相似成本**：預期 - 每個子代理的任務複雜性相似
- **每個任務的成本**：典型範圍為每個子代理 $0.05-$0.15，具體取決於任務

## 故障排除

### 技能未加載

**問題**：運行無頭測試時找不到技能

**解決方案**：
1. 確保您正在從 superpowers 目錄運行：`cd /path/to/superpowers && tests/...`
2. 查看`~/.claude/settings.json`有`"superpowers@superpowers-dev": true`在`enabledPlugins`
3. 驗證技能存在於`skills/`目錄

### 權限錯誤

**問題**：克勞德被阻止寫入檔案或存取目錄

**解決方案**：
1. 使用`--permission-mode bypassPermissions`旗幟
2. 使用`--add-dir /path/to/temp/dir`授予對測試目錄的存取權限
3. 檢查測試目錄的文件權限

### 測試超時

**問題**：測試時間太長並且超時

**解決方案**：
1. 增加超時：`timeout 1800 claude ...`（30分鐘）
2. 檢查技能邏輯是否存在無限循環
3. 檢查子代理任務複雜性

### 未找到會話文件

**問題**：測試運行後找不到會話記錄

**解決方案**：
1. 檢查正確的項目目錄`~/.claude/projects/`
2. 使用`find ~/.claude/projects -name "*.jsonl" -mmin -60`查找最近的會話
3. 驗證測試實際運作（檢查測試輸出是否有錯誤）

## 編寫新的集成測試

### 模板

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

# Create test project
TEST_PROJECT=$(create_test_project)
trap "cleanup_test_project $TEST_PROJECT" EXIT

# Set up test files...
cd "$TEST_PROJECT"

# Run Claude with skill
PROMPT="Your test prompt here"
cd "$SCRIPT_DIR/../.." && timeout 1800 claude -p "$PROMPT" \
  --allowed-tools=all \
  --add-dir "$TEST_PROJECT" \
  --permission-mode bypassPermissions \
  2>&1 | tee output.txt

# Find and analyze session
WORKING_DIR_ESCAPED=$(echo "$SCRIPT_DIR/../.." | sed 's/\\//-/g' | sed 's/^-//')
SESSION_DIR="$HOME/.claude/projects/$WORKING_DIR_ESCAPED"
SESSION_FILE=$(find "$SESSION_DIR" -name "*.jsonl" -type f -mmin -60 | sort -r | head -1)

# Verify behavior by parsing session transcript
if grep -q '"name":"Skill".*"skill":"your-skill-name"' "$SESSION_FILE"; then
    echo "[PASS] Skill was invoked"
fi

# Show token analysis
python3 "$SCRIPT_DIR/analyze-token-usage.py" "$SESSION_FILE"
```

### 最佳實踐

1. **始終清理**：使用 trap 清理臨時目錄
2. **解析成績單**：不要 grep 面向用戶的輸出 - 解析`.jsonl`會話文件
3. **授予權限**：使用`--permission-mode bypassPermissions`和`--add-dir`
4. **從插件目錄運行**：技能僅在從 superpowers 目錄運行時加載
5. **顯示代幣使用情況**：始終包含代幣分析以實現成本可見性
6. **測試真實行為**：驗證實際建立的文件、測試通過、提交

## 會議記錄格式

會話記錄是 JSONL（JSON 行）文件，其中每行都是表示消息或工具結果的 JSON 對象。

### 重點領域

```json
{
  "type": "assistant",
  "message": {
    "content": [...],
    "usage": {
      "input_tokens": 27,
      "output_tokens": 3996,
      "cache_read_input_tokens": 1213703
    }
  }
}
```

### 工具結果

```json
{
  "type": "user",
  "toolUseResult": {
    "agentId": "3380c209",
    "usage": {
      "input_tokens": 2,
      "output_tokens": 787,
      "cache_read_input_tokens": 24989
    },
    "prompt": "You are implementing Task 1...",
    "content": [{"type": "text", "text": "..."}]
  }
}
```

這`agentId`到子代理會話的字段鏈接，以及`usage`字段包含該特定子代理調用的令牌使用情況。
