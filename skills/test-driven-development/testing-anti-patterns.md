# 測試反模式

**在以下情況下載入此參考：** 編寫或更改測試、新增模擬或試圖將僅測試方法新增至生產程式碼。

## 概述

測試必須驗證真實行為，而不是模擬行為。模擬是一種隔離手段，而不是被測試的東西。

**核心原則：** 測試程式碼做什麼，而不是模擬做什麼。

**遵循嚴格的TDD可以防止這些反模式。 **

## 鐵律

```
1. NEVER test mock behavior
2. NEVER add test-only methods to production classes
3. NEVER mock without understanding dependencies
```

## 反模式 1：測試模擬行為

**違規行為：**
```typescript
// ❌ BAD: Testing that the mock exists
test('renders sidebar', () => {
  render(<Page />);
  expect(screen.getByTestId('sidebar-mock')).toBeInTheDocument();
});
```

**為什麼這是錯的：**
- 您正在驗證模擬是否有效，而不是元件是否有效
- 當模擬存在時測試通過，當模擬不存在時測試失敗
- 不會告訴您任何有關真實行為的信息

**你的人類夥伴的更正：**“我們正在測試模擬的行為嗎？”

**修復：**
```typescript
// ✅ GOOD: Test real component or don't mock it
test('renders sidebar', () => {
  render(<Page />);  // Don't mock sidebar
  expect(screen.getByRole('navigation')).toBeInTheDocument();
});

// OR if sidebar must be mocked for isolation:
// Don't assert on the mock - test Page's behavior with sidebar present
```

### 門功能

```
BEFORE asserting on any mock element:
  Ask: "Am I testing real component behavior or just mock existence?"

  IF testing mock existence:
    STOP - Delete the assertion or unmock the component

  Test real behavior instead
```

## 反模式 2：生產中的僅測試方法

**違規行為：**
```typescript
// ❌ BAD: destroy() only used in tests
class Session {
  async destroy() {  // Looks like production API!
    await this._workspaceManager?.destroyWorkspace(this.id);
    // ... cleanup
  }
}

// In tests
afterEach(() => session.destroy());
```

**為什麼這是錯的：**
- 生產類被僅測試代碼污染
- 如果在生產中意外調用會很危險
- 違反 YAGNI 和關注點分離
- 混淆了物件生命週期和實體生命週期

**修復：**
```typescript
// ✅ GOOD: Test utilities handle test cleanup
// Session has no destroy() - it's stateless in production

// In test-utils/
export async function cleanupSession(session: Session) {
  const workspace = session.getWorkspaceInfo();
  if (workspace) {
    await workspaceManager.destroyWorkspace(workspace.id);
  }
}

// In tests
afterEach(() => cleanupSession(session));
```

### 門功能

```
BEFORE adding any method to production class:
  Ask: "Is this only used by tests?"

  IF yes:
    STOP - Don't add it
    Put it in test utilities instead

  Ask: "Does this class own this resource's lifecycle?"

  IF no:
    STOP - Wrong class for this method
```

## 反模式 3：不理解的嘲笑

**違規行為：**
```typescript
// ❌ BAD: Mock breaks test logic
test('detects duplicate server', () => {
  // Mock prevents config write that test depends on!
  vi.mock('ToolCatalog', () => ({
    discoverAndCacheTools: vi.fn().mockResolvedValue(undefined)
  }));

  await addServer(config);
  await addServer(config);  // Should throw - but won't!
});
```

**為什麼這是錯的：**
- 模擬方法有依賴於副作用測試（編寫配置）
- 為了「安全」而過度嘲笑會破壞實際行為
- 測試因錯誤原因通過或神祕失敗

**修復：**
```typescript
// ✅ GOOD: Mock at correct level
test('detects duplicate server', () => {
  // Mock the slow part, preserve behavior test needs
  vi.mock('MCPServerManager'); // Just mock slow server startup

  await addServer(config);  // Config written
  await addServer(config);  // Duplicate detected ✓
});
```

### 門功能

```
BEFORE mocking any method:
  STOP - Don't mock yet

  1. Ask: "What side effects does the real method have?"
  2. Ask: "Does this test depend on any of those side effects?"
  3. Ask: "Do I fully understand what this test needs?"

  IF depends on side effects:
    Mock at lower level (the actual slow/external operation)
    OR use test doubles that preserve necessary behavior
    NOT the high-level method the test depends on

  IF unsure what test depends on:
    Run test with real implementation FIRST
    Observe what actually needs to happen
    THEN add minimal mocking at the right level

  Red flags:
    - "I'll mock this to be safe"
    - "This might be slow, better mock it"
    - Mocking without understanding the dependency chain
```

## 反模式 4：不完整的模擬

**違規行為：**
```typescript
// ❌ BAD: Partial mock - only fields you think you need
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' }
  // Missing: metadata that downstream code uses
};

// Later: breaks when code accesses response.metadata.requestId
```

**為什麼這是錯的：**
- **部分模擬隱藏了結構假設** - 您只模擬了您知道的字段
- **下游程式碼可能取決於您未包含的欄位** - 無提示失敗
- **測試但整合失敗** - 模擬不完整，真實API完整
- **虛假信心** - 測試無法證明真實行為

**鐵律：** 模擬現實中存在的完整資料結構，而不僅僅是您直接測試使用的欄位。

**修復：**
```typescript
// ✅ GOOD: Mirror real API completeness
const mockResponse = {
  status: 'success',
  data: { userId: '123', name: 'Alice' },
  metadata: { requestId: 'req-789', timestamp: 1234567890 }
  // All fields real API returns
};
```

### 門功能

```
BEFORE creating mock responses:
  Check: "What fields does the real API response contain?"

  Actions:
    1. Examine actual API response from docs/examples
    2. Include ALL fields system might consume downstream
    3. Verify mock matches real response schema completely

  Critical:
    If you're creating a mock, you must understand the ENTIRE structure
    Partial mocks fail silently when code depends on omitted fields

  If uncertain: Include all documented fields
```

## 反模式 5：事後才考慮整合測試

**違規行為：**
```
✅ Implementation complete
❌ No tests written
"Ready for testing"
```

**為什麼這是錯的：**
- 測試是實施的一部分，而不是可選的後續行動
- TDD 會發現這個
- 沒有測試就不能聲稱完整

**修復：**
```
TDD cycle:
1. Write failing test
2. Implement to pass
3. Refactor
4. THEN claim complete
```

## 當模擬變得太複雜時

**警告標誌：**
- 模擬設置比測試邏輯長
- 模擬一切以使測試通過
- 模擬缺少真實組件所具有的方法
- 當模擬更改時測試會中斷

**你的人類夥伴的問題：**“我們需要在這裡使用模擬嗎？”

**考慮：** 與真實組件的整合測試通常比複雜的模擬更簡單

## TDD 可以阻止這些反模式

**為什麼TDD有幫助：**
1. **首先編寫測試** → 迫使您思考您實際測試的內容
2. **看著它失敗** → 確認測試測試真實行為，而不是模擬
3. **最小實現** → 沒有純測試方法
4. **真正的依賴關係** → 在模擬之前您會看到測試實際上需要什麼

**如果您正在測試模擬行為，則違反了TDD** - 您新增了模擬，而沒有先觀察真實計劃碼的測試失敗。

## 快速參考

|反模式 |修復 |
|--------------|-----|
|對模擬元素進行斷言 |測試真實組件或解鎖它 |
|生產中的僅測試方法 |移至測試實用程式 |
|沒有理解的嘲笑|先了解依賴關係，最小化模擬 |
|不完整的模擬|完全鏡像真實API |
|事後才進行測驗| TDD - 先測試|
|過於複雜的模擬 |考慮整合測試 |

## 危險信號

- 斷言檢查`*-mock`測試ID
- 僅在測試檔案中呼叫的方法
- 模擬設定 > 測試的 50%
- 刪除模擬時測試失敗
- 無法解釋為什麼需要模擬
- 嘲笑“只是為了安全”

## 底線

**模擬是隔離的工具，而不是測試的東西。 **

如果 TDD 顯示您正在測試模擬行為，那麼您就錯了。

修復：測試真實行為或質疑你為什麼要嘲笑。
