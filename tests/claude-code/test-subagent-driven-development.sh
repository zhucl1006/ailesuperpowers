#!/usr/bin/env bash
# 測試：subagent-driven-development 技能
# 驗證技能可被辨識，且流程順序符合規範
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

# Claude CLI 偶發會返回空輸出；重試可降低測試波動。
run_claude_with_retry() {
    local prompt="$1"
    local timeout="$2"
    local attempts="${3:-2}"
    local allowed_tools="${4:-Read,Grep,Glob}"
    local output=""

    for ((i = 1; i <= attempts; i++)); do
        output=$(run_claude "$prompt" "$timeout" "$allowed_tools" || true)
        if [ -n "$(echo "$output" | tr -d '[:space:]')" ]; then
            echo "$output"
            return 0
        fi
        sleep 1
    done

    echo "$output"
    return 0
}

echo "=== 測試：subagent-driven-development 技能 ==="
echo ""

# 測試 1：驗證技能可被載入
echo "測試 1：技能載入..."

output=$(run_claude_with_retry "請說明 subagent-driven-development 技能，並簡述關鍵步驟（需提到計畫讀取或任務提取）。" 120)

if assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|Subagent Driven\|子代理驅動\|子代理" "技能已被辨識"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Load Plan\|read.*plan\|extract.*tasks\|讀.*計畫\|读取.*计划\|提取.*任務\|提取.*任务" "提到計畫讀取/任務提取"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 2：驗證流程順序
echo "測試 2：流程順序..."

output=$(run_claude_with_retry "在 subagent-driven-development 中，規範合規審查與程式碼品質審查哪個先做？請明確說明順序。" 120)

if assert_contains "$output" "spec.*compliance.*code.*quality\|規範.*合規.*程式碼.*品質\|規格.*合規.*代碼.*質量\|规范.*合规.*代码.*质量\|先.*規範.*後.*程式碼\|先.*规范.*后.*代码" "先規範合規，再程式碼品質"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 3：驗證自我審查要求
echo "測試 3：自我審查要求..."

output=$(run_claude_with_retry "subagent-driven-development 是否要求實作者先做自我審查？應該檢查哪些內容？" 120)

if assert_contains "$output" "self-review\|self review\|自我審查\|自我审查\|自我检查\|自查" "提到自我審查"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "completeness\|Completeness\|完整性\|是否完整\|是否遺漏\|是否遗漏\|遺漏\|遗漏\|覆蓋\|覆盖" "提到完整性檢查"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 4：驗證計畫只讀一次
echo "測試 4：計畫讀取效率..."

output=$(run_claude_with_retry "根據 subagent-driven-development 的流程，控制者讀取計畫檔是「一次」還是「多次」？請先明確回答一次/多次，再說明時機。" 120)

if assert_contains "$output" "once\|one time\|single\|一次\|單次\|只讀一次\|只读取一次\|僅一次\|仅一次\|ONCE" "計畫只讀一次"; then
    : # pass
else
    exit 1
fi

if assert_not_contains "$output" "多次\|兩次\|2次\|二次\|twice\|multiple\|MULTIPLE" "不是多次讀取"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Step 1\|beginning\|start\|Load Plan\|第一步\|開始\|开始\|開頭\|起始\|起始階段\|开始阶段" "在開始階段讀取"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 5：驗證規範審查者的懷疑態度
echo "測試 5：規範審查者心態..."

output=$(run_claude_with_retry "在 subagent-driven-development 的規範審查中，若原則是「不要信任實作者回報，需獨立驗證並直接閱讀程式碼」，審查者應持什麼態度？" 120)

if assert_contains "$output" "not trust\|don't trust\|skeptical\|verify.*independently\|suspiciously\|不信任\|保持懷疑\|保持怀疑\|懷疑\|怀疑\|獨立驗證\|独立验证" "審查者保持懷疑並獨立驗證"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "read.*code\|inspect.*code\|verify.*code\|讀.*程式碼\|讀取.*程式碼\|阅读.*代码\|查看.*代码\|检查.*代码\|檢查.*程式碼" "審查者會直接看程式碼"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 6：驗證審查循環
echo "測試 6：審查循環要求..."

output=$(run_claude_with_retry "在 subagent-driven-development 中，如果審查者發現問題會怎麼處理？是一次性審查還是循環？" 120)

if assert_contains "$output" "loop\|again\|repeat\|until.*approved\|until.*compliant\|循環\|循环\|反覆\|反复\|直到.*通過\|直到.*通过\|直到.*合規\|直到.*合规\|直至.*批准\|直到.*批准" "提到審查循環"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "implementer.*fix\|fix.*issues\|實作者.*修復\|实施者.*修复" "實作者會修復問題"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 7：驗證任務上下文提供方式
echo "測試 7：任務上下文提供..."

output=$(run_claude_with_retry "在 subagent-driven-development 中，控制者如何把任務資訊給實作者子代理？是要求讀檔，還是直接提供完整文本？" 120)

if assert_contains "$output" "provide.*directly\|full.*text\|paste\|include.*prompt\|直接提供\|完整文本\|完整任務\|直接貼上" "直接提供完整任務內容"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "don't make subagent read file\|改為提供全文\|改为提供全文\|避免.*讀取.*檔案\|避免.*读取.*文件\|無檔案讀取開銷\|无文件读取开销" "不要求子代理自行讀檔"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 8：驗證 worktree 前置要求
echo "測試 8：worktree 前置要求..."

output=$(run_claude_with_retry "根據 subagent-driven-development 文件「一體化/所需工作流程技能」段落，開始前是否必須 using-git-worktrees（worktree）？請直接回答並列出前置技能。" 120)

if assert_contains "$output" "using-git-worktrees\|worktree\|git 工作樹\|工作樹" "提到 worktree 要求"; then
    : # pass
else
    exit 1
fi

echo ""

# 測試 9：驗證 main 分支警示
echo "測試 9：main 分支警示..."

output=$(run_claude_with_retry "在 subagent-driven-development 中，可以直接在 main 分支開始實作嗎？" 120)

if assert_contains "$output" "worktree\|feature.*branch\|not.*main\|never.*main\|avoid.*main\|don't.*main\|consent\|permission\|不要.*main\|不可.*main\|避免.*main\|不能.*main\|主分支\|主干\|需.*同意\|需要.*許可" "警告不要直接在 main 實作"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== subagent-driven-development 技能測試全部通過 ==="
