# 根據使用者回饋改進技能

**日期：** 2025-11-28
**狀態：** 草案
**來源：** 兩個在真實開發場景中使用超能力的克勞德實例

---

## 執行摘要

兩個克勞德實例提供了實際開發會議的詳細反饋。他們的反饋揭示了當前技能中的**系統性差距**，儘管遵循了技能，但仍允許可預防的錯誤出現。

**批判性見解：** 這些是問題報告，而不僅僅是解決方案建議。問題是真實存在的；解決方案需要仔細評估。

**關鍵主題：**
1. **驗證差距** - 我們驗證操作是否成功，但不驗證它們是否實現了預期結果
2. **進程衛生** - 後臺進程累積並幹擾子代理
3. **上下文優化** - 子代理程式獲取太多不相關的信息
4. **缺乏自我反思** - 交接前沒有提示批評自己的工作
5. **模擬安全性** - 模擬可能會在沒有偵測到的情況下偏離介面
6. **技能啟動** - 技能存在但未被讀取/使用

---

## 發現的問題

### 問題 1：配置更改驗證差距

**發生了什麼事：**
- 子代理測試了“OpenAI 集成”
- 放`OPENAI_API_KEY`環境變量
- 收到狀態 200 回覆
- 報告“OpenAI 整合工作”
- **但是**包含回覆`"model": "claude-sonnet-4-20250514"`- 實際上正在使用 Anthropic

**根本原因：**
`verification-before-completion`檢查操作是否成功，但不檢查結果反映預期的配置更改。

**影響：** 高 - 對集成測試的錯誤信心，將錯誤發送到生產環境

**故障模式示例：**
- 切換LLM提供者→驗證狀態200但不檢查型號名稱
- 啟用功能標誌 → 驗證沒有錯誤，但不檢查功能是否處於活動狀態
- 更改環境→驗證部署是否成功，但不檢查環境變量

---

### 問題二：後臺流程堆積

**發生了什麼事：**
- 會話期間調度多個子代理
- 每個啟動的後臺服務器進程
- 累積進程（4+臺服務器運行）
- 過時的進程仍然綁定到端口
- 後來的 E2E 測試遇到配置錯誤的陳舊服務器
- 令人困惑/不正確的測試結果

**根本原因：**
子代理是無狀態的 - 不知道以前的子代理的進程。沒有清理協議。

**影響：** 中-高 - 測試命中錯誤的伺服器、錯誤通過/失敗、調試混亂

---

### 問題 3：子代理程式提示中的上下文膨脹

**發生了什麼事：**
- 標準方法：給子代理完整的計劃文件以供讀取
- 實驗：只給出任務+模式+文件+驗證命令
- 結果：更快、更專注、單次嘗試完成更常見

**根本原因：**
子代理將令牌和注意力浪費在不相關的計劃部分。

**影響：** 中 - 執行速度較慢，失敗嘗試較多

**什麼有效：**
```
You are adding a single E2E test to packnplay's test suite.

**Your task:** Add `TestE2E_FeaturePrivilegedMode` to `pkg/runner/e2e_test.go`

**What to test:** A local devcontainer feature that requests `"privileged": true`
in its metadata should result in the container running with `--privileged` flag.

**Follow the exact pattern of TestE2E_FeatureOptionValidation** (at the end of the file)

**After writing, run:** `go test -v ./pkg/runner -run TestE2E_FeaturePrivilegedMode -timeout 5m`
```

---

### 問題四：交接前沒有自我反思

**發生了什麼事：**
- 新增了自我反思提示：“用新的眼光審視你的工作——還有什麼可以更好的呢？”
- 任務 5 的實施者發現失敗的測試是由於實施錯誤而不是測試錯誤
- 追蹤到第99行：`strings.Join(metadata.Entrypoint, " ")`創建無效的 Docker 語法
- 如果沒有自我反思，就會報告“測試失敗”而沒有根本原因

**根本原因：**
在報告完成情況之前，實施者不會自然地退後一步並批評自己的工作。

**影響：** 中 - 將實施者可能發現的錯誤移交給審閱者

---

### 問題 5：模擬接口漂移

**發生了什麼事：**
```typescript
// Interface defines close()
interface PlatformAdapter {
  close(): Promise<void>;
}

// Code (BUGGY) calls cleanup()
await adapter.cleanup();

// Mock (MATCHES BUG) defines cleanup()
vi.mock('web-adapter', () => ({
  WebAdapter: vi.fn().mockImplementation(() => ({
    cleanup: vi.fn().mockResolvedValue(undefined),  // Wrong!
  })),
}));
```
- 測試通過
- 運行時崩潰：“adapter.cleanup 不是函數”

**根本原因：**
模擬源自有缺陷的程式碼調用，而不是源自於介面定義。 TypeScript 無法擷取方法名稱錯誤的內嵌模擬。

**影響：** 高 - 測試給予錯誤的信心，運行時崩潰

**為什麼測試反模式不能阻止這種情況：**
該技能涵蓋測試模擬行為和在不理解的情況下進行模擬，但不包括「從介面而不是實現派生模擬」的具體模式。

---

### 問題 6：Code Reviewer 檔案訪問

**發生了什麼事：**
- 已派遣代碼審查員子代理
- 找不到測試文件：“該文件似乎不存在於存儲庫中”
- 文件確實存在
- 審稿者不知道先明確閱讀它

**根本原因：**
審閱者提示不包括明確的文件讀取說明。

**影響：** 低-中 - 審核失敗或不完整

---

### 問題 7：修復工作流程延遲

**發生了什麼事：**
- 實施者在自我反思中發現錯誤
- 實施者知道修​​​​複方法
- 當前工作流程：報告→我派遣修復程序→修復程序修復→我驗證
- 額外的往返會增加延遲，但不會增加價值

**根本原因：**
當實施者已經診斷時，實施者和修復者角色之間的嚴格分離。

**影響：** 低 - 延遲，但沒有正確性問題

---

### 問題8：技能未被閱讀

**發生了什麼事：**
- `testing-anti-patterns`技能存在
- 在編寫測試之前，人類和子代理程式都不會閱讀它
- 可以避免一些問題（儘管不是全部 - 請參閱問題 5）

**根本原因：**
沒有強制子代理閱讀相關技能。沒有提示包含技能閱讀。

**影響：** 中 - 如果不使用技能投資就會浪費

---

## 改進建議

### 1、verification-before-completion：新增設定變更驗證

**新增部分：**

```markdown
## Verifying Configuration Changes

When testing changes to configuration, providers, feature flags, or environment:

**Don't just verify the operation succeeded. Verify the output reflects the intended change.**

### Common Failure Pattern

Operation succeeds because *some* valid config exists, but it's not the config you intended to test.

### Examples

| Change | Insufficient | Required |
|--------|-------------|----------|
| Switch LLM provider | Status 200 | Response contains expected model name |
| Enable feature flag | No errors | Feature behavior actually active |
| Change environment | Deploy succeeds | Logs/vars reference new environment |
| Set credentials | Auth succeeds | Authenticated user/context is correct |

### Gate Function

```
在聲明配置更改有效之前：

1. 識別：此更改後應該有什麼不同？
2. 定位：在哪裡可以觀察到這種差異？
   - 回應欄位（型號名稱、使用者 ID）
   - 日誌行（環境、提供者）
   - 行為（功能激活/非激活）
3. RUN：顯示可觀察到的差異的指令
4. 驗證：輸出包含預期差異
5. 只有這樣：聲明配置更改纔有效

危險信號：
  - 未檢查內容“請求成功”
  - 檢查狀態代碼但不檢查響應正文
  - 驗證沒有錯誤但未正面確認
```

**Why this works:**
Forces verification of INTENT, not just operation success.

---

### 2. subagent-driven-development: Add Process Hygiene for E2E Tests

**Add new section:**

```markdown
## E2E 測試的流程衛生

調度啟動服務（服務器、數據庫、消息隊列）的子代理時：

### 問題

子代理程式是無狀態的 - 它們不知道先前子代理程式啟動的進程。後臺進程持續存在並可能幹擾後續測試。

### 解決方案

**在分派 E2E 測試子代理程式之前，請在提示中包含清理：**

```
BEFORE starting any services:
1. Kill existing processes: pkill -f "<service-pattern>" 2>/dev/null || true
2. Wait for cleanup: sleep 1
3. Verify port free: lsof -i :<port> && echo "ERROR: Port still in use" || echo "Port free"

AFTER tests complete:
1. Kill the process you started
2. Verify cleanup: pgrep -f "<service-pattern>" || echo "Cleanup successful"
```

### 例子

```
Task: Run E2E test of API server

Prompt includes:
"Before starting the server:
- Kill any existing servers: pkill -f 'node.*server.js' 2>/dev/null || true
- Verify port 3001 is free: lsof -i :3001 && exit 1 || echo 'Port available'

After tests:
- Kill the server you started
- Verify: pgrep -f 'node.*server.js' || echo 'Cleanup verified'"
```

### 為什麼這很重要

- 過時的進程使用錯誤的配置來處理請求
- 端口衝突導致靜默故障
- 進程累積會減慢系統速度
- 令人困惑的測試結果（擊中了錯誤的伺服器）
```

**Trade-off analysis:**
- Adds boilerplate to prompts
- But prevents very confusing debugging
- Worth it for E2E test subagents

---

### 3. subagent-driven-development: Add Lean Context Option

**Modify Step 2: Execute Task with Subagent**

**Before:**
```
從[計劃文件]中仔細閱讀該任務。
```

**After:**
```
## 情境方法

**完整計劃（預設）：**
當任務複雜或具有相依性時使用：
```
Read Task N from [plan-file] carefully.
```

**精實情境（針對獨立任務）：**
當任務是獨立且基於模式時使用：
```
You are implementing: [1-2 sentence task description]

File to modify: [exact path]
Pattern to follow: [reference to existing function/test]
What to implement: [specific requirement]
Verification: [exact command to run]

[Do NOT include full plan file]
```

**在以下情況下使用精實環境：**
- 任務遵循現有模式（添加類似的測試，實現類似的功能）
- 任務是獨立的（不需要其他任務的上下文）
- 模式參考就足夠了（e.g.，“遵循TestE2E_FeatureOptionValidation”）

**在以下情況下使用完整計劃：**
- 任務依賴於其他任務
- 需要了解整體架構
- 需要上下文的複雜邏輯
```

**Example:**
```
精實上下文提示：

“您正在開發容器功能中添加特權模式測試。

文件：pkg/runner/e2e_test.go
模式：遵循 TestE2E_FeatureOptionValidation （在文件末尾）
測試：特徵`"privileged": true`元數據結果`--privileged`旗幟
驗證： go test -v ./pkg/runner -run TestE2E_FeaturePrivilegedMode -timeout 5m

報告：實施、測試結果、任何問題。 」
```

**Why this works:**
Reduces token usage, increases focus, faster completion when appropriate.

---

### 4. subagent-driven-development: Add Self-Reflection Step

**Modify Step 2: Execute Task with Subagent**

**Add to prompt template:**

```
完成後，在報告之前：

退後一步，用新的眼光審視你的工作。

問問自己：
- 這是否真的解決了指定的任務？
- 有沒有我沒有考慮到的邊緣情況？
- 我是否正確遵循了該模式？
- 如果測試失敗，根本原因是什麼（實作錯誤與測試錯誤）？
- 此實施還有什麼可以更好的地方？

如果您在反思過程中發現問題，請立即解決它們。

然後報告：
- 你實施了什麼
- 自我反思發現（如果有）
- 測試結果
- 文件已更改
```

**Why this works:**
Catches bugs implementer can find themselves before handoff. Documented case: identified entrypoint bug through self-reflection.

**Trade-off:**
Adds ~30 seconds per task, but catches issues before review.

---

### 5. requesting-code-review: Add Explicit File Reading

**Modify the code-reviewer template:**

**Add at the beginning:**

```markdown
## 要審查的文件

在分析之前，請先閱讀這些文件：

1. [列出差異中更改的特定文件]
2. [更改引用但未修改的文件]

使用讀取工具加載每個文件。

如果找不到文件：
- 檢查 diff 的確切路徑
- 嘗試其他位置
- 報告：“無法找到 [路徑] - 請驗證文件是否存在”

在閱讀實際代碼之前，請勿繼續進行審查。
```

**Why this works:**
Explicit instruction prevents "file not found" issues.

---

### 6. testing-anti-patterns: Add Mock-Interface Drift Anti-Pattern

**Add new Anti-Pattern 6:**

```markdown
## 反模式 6：源自實現的模擬

**違規行為：**
```typescript
// Code (BUGGY) calls cleanup()
await adapter.cleanup();

// Mock (MATCHES BUG) has cleanup()
const mock = {
  cleanup: vi.fn().mockResolvedValue(undefined)
};

// Interface (CORRECT) defines close()
interface PlatformAdapter {
  close(): Promise<void>;
}
```

**為什麼這是錯的：**
- 模擬將錯誤編碼到測試中
- TypeScript 無法擷取方法名稱錯誤的內嵌模擬
- 測試通過，因為程式碼和模擬都錯誤
- 使用真實對象時運行時崩潰

**修復：**
```typescript
// ✅ GOOD: Derive mock from interface

// Step 1: Open interface definition (PlatformAdapter)
// Step 2: List methods defined there (close, initialize, etc.)
// Step 3: Mock EXACTLY those methods

const mock = {
  initialize: vi.fn().mockResolvedValue(undefined),
  close: vi.fn().mockResolvedValue(undefined),  // From interface!
};

// Now test FAILS because code calls cleanup() which doesn't exist
// That failure reveals the bug BEFORE runtime
```

### 門功能

```
BEFORE writing any mock:

  1. STOP - Do NOT look at the code under test yet
  2. FIND: The interface/type definition for the dependency
  3. READ: The interface file
  4. LIST: Methods defined in the interface
  5. MOCK: ONLY those methods with EXACTLY those names
  6. DO NOT: Look at what your code calls

  IF your test fails because code calls something not in mock:
    ✅ GOOD - The test found a bug in your code
    Fix the code to call the correct interface method
    NOT the mock

  Red flags:
    - "I'll mock what the code calls"
    - Copying method names from implementation
    - Mock written without reading interface
    - "The test is failing so I'll add this method to the mock"
```

**檢測：**

當您看到運行時錯誤“X 不是函數”並且測試通過時：
1. 檢查 X 是否被嘲笑
2. 將模擬方法與接口方法進行比較
3. 尋找方法名稱不符的地方
```

**Why this works:**
Directly addresses the failure pattern from feedback.

---

### 7. subagent-driven-development: Require Skills Reading for Test Subagents

**Add to prompt template when task involves testing:**

```markdown
在編寫任何測試之前：

1. 閱讀測驗反模式技能：
使用技能工具：superpowers:testing-anti-patterns

2. 在以下情況下應用該技能的門函數：
   - 編寫模擬
   - 將方法添加到生產類
   - 模擬依賴關係

這不是可選的。違反反模式的測試將在審查中被拒絕。
```

**Why this works:**
Ensures skills are actually used, not just exist.

**Trade-off:**
Adds time to each task, but prevents entire classes of bugs.

---

### 8. subagent-driven-development: Allow Implementer to Fix Self-Identified Issues

**Modify Step 2:**

**Current:**
```
子代理報告工作總結。
```

**Proposed:**
```
子agent進行自我反思，則：

如果自我反思發現了可以解決的問題：
  1. 修復問題
  2. 重新運行驗證
  3. 報告：“初步實施+自我反思修復”

別的：
報告：“實施完成”

包含在報告中：
- 自我反思發現
- 是否應用了修復
- 最終驗證結果
```

**Why this works:**
Reduces latency when implementer already knows the fix. Documented case: would have saved one round-trip for entrypoint bug.

**Trade-off:**
Slightly more complex prompt, but faster end-to-end.

---

## Implementation Plan

### Phase 1: High-Impact, Low-Risk (Do First)

1. **verification-before-completion: Configuration change verification**
   - Clear addition, doesn't change existing content
   - Addresses high-impact problem (false confidence in tests)
   - File: `skills/verification-before-completion/SKILL.md`

2. **testing-anti-patterns: Mock-interface drift**
   - Adds new anti-pattern, doesn't modify existing
   - Addresses high-impact problem (runtime crashes)
   - File: `skills/testing-anti-patterns/SKILL.md`

3. **requesting-code-review: Explicit file reading**
   - Simple addition to template
   - Fixes concrete problem (reviewers can't find files)
   - File: `skills/requesting-code-review/SKILL.md`

### Phase 2: Moderate Changes (Test Carefully)

4. **subagent-driven-development: Process hygiene**
   - Adds new section, doesn't change workflow
   - Addresses medium-high impact (test reliability)
   - File: `skills/subagent-driven-development/SKILL.md`

5. **subagent-driven-development: Self-reflection**
   - Changes prompt template (higher risk)
   - But documented to catch bugs
   - File: `skills/subagent-driven-development/SKILL.md`

6. **subagent-driven-development: Skills reading requirement**
   - Adds prompt overhead
   - But ensures skills are actually used
   - File: `skills/subagent-driven-development/SKILL.md`

### Phase 3: Optimization (Validate First)

7. **subagent-driven-development: Lean context option**
   - Adds complexity (two approaches)
   - Needs validation that it doesn't cause confusion
   - File: `skills/subagent-driven-development/SKILL.md`

8. **subagent-driven-development: Allow implementer to fix**
   - Changes workflow (higher risk)
   - Optimization, not bug fix
   - File: `skills/subagent-driven-development/SKILL.md`

---

## Open Questions

1. **Lean context approach:**
   - Should we make it the default for pattern-based tasks?
   - How do we decide which approach to use?
   - Risk of being too lean and missing important context?

2. **Self-reflection:**
   - Will this slow down simple tasks significantly?
   - Should it only apply to complex tasks?
   - How do we prevent "reflection fatigue" where it becomes rote?

3. **Process hygiene:**
   - Should this be in subagent-driven-development or a separate skill?
   - Does it apply to other workflows beyond E2E tests?
   - How do we handle cases where process SHOULD persist (dev servers)?

4. **Skills reading enforcement:**
   - Should we require ALL subagents to read relevant skills?
   - How do we keep prompts from becoming too long?
   - Risk of over-documenting and losing focus?

---

## Success Metrics

How do we know these improvements work?

1. **Configuration verification:**
   - Zero instances of "test passed but wrong config was used"
   - Jesse doesn't say "that's not actually testing what you think"

2. **Process hygiene:**
   - Zero instances of "test hit wrong server"
   - No port conflict errors during E2E test runs

3. **Mock-interface drift:**
   - Zero instances of "tests pass but runtime crashes on missing method"
   - No method name mismatches between mocks and interfaces

4. **Self-reflection:**
   - Measurable: Do implementer reports include self-reflection findings?
   - Qualitative: Do fewer bugs make it to code review?

5. **Skills reading:**
   - Subagent reports reference skill gate functions
   - Fewer anti-pattern violations in code review

---

## Risks and Mitigations

### Risk: Prompt Bloat
**Problem:** Adding all these requirements makes prompts overwhelming
**Mitigation:**
- Phase implementation (don't add everything at once)
- Make some additions conditional (E2E hygiene only for E2E tests)
- Consider templates for different task types

### Risk: Analysis Paralysis
**Problem:** Too much reflection/verification slows execution
**Mitigation:**
- Keep gate functions quick (seconds, not minutes)
- Make lean context opt-in initially
- Monitor task completion times

### Risk: False Sense of Security
**Problem:** Following checklist doesn't guarantee correctness
**Mitigation:**
- Emphasize gate functions are minimums, not maximums
- Keep "use judgment" language in skills
- Document that skills catch common failures, not all failures

### Risk: Skill Divergence
**Problem:** Different skills give conflicting advice
**Mitigation:**
- Review changes across all skills for consistency
- Document how skills interact (Integration sections)
- Test with real scenarios before deployment

---

## Recommendation

**Proceed with Phase 1 immediately:**
- verification-before-completion: Configuration change verification
- testing-anti-patterns: Mock-interface drift
- requesting-code-review: Explicit file reading

**Test Phase 2 with Jesse before finalizing:**
- Get feedback on self-reflection impact
- Validate process hygiene approach
- Confirm skills reading requirement is worth overhead

**Hold Phase 3 pending validation:**
- Lean context needs real-world testing
- Implementer-fix workflow change needs careful evaluation

These changes address real problems documented by users while minimizing risk of making skills worse.
