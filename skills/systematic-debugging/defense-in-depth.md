# 縱深防禦驗證

## 概述

當您修復由無效資料引起的錯誤時，在一個地方新增驗證就足夠了。但這一單一檢查可以透過不同的程式碼路徑、重構或模擬來繞過。

**核心原則：** 在數據通過的每一層進行驗證。使該錯誤在結構上變得不可能。

## 為什麼要多層

單一驗證：“我們修復了錯誤”
多層：“我們讓錯誤變得不可能”

不同的層捕獲不同的情況：
- 條目驗證捕獲大多數錯誤
- 業務邏輯擷取邊緣情況
- 環保衛士預防特定環境的危險
- 當其他層失敗時，調試日誌記錄會有所幫助

## 四層

### 第一層：入口點驗證
** 目的：** 在 API 邊界拒絕一個明顯無效的輸入

```typescript
function createProject(name: string, workingDirectory: string) {
  if (!workingDirectory || workingDirectory.trim() === '') {
    throw new Error('workingDirectory cannot be empty');
  }
  if (!existsSync(workingDirectory)) {
    throw new Error(`workingDirectory does not exist: ${workingDirectory}`);
  }
  if (!statSync(workingDirectory).isDirectory()) {
    throw new Error(`workingDirectory is not a directory: ${workingDirectory}`);
  }
  // ... proceed
}
```

### 第 2 層：業務邏輯驗證
**目的：** 確保數據對於此操作有意義

```typescript
function initializeWorkspace(projectDir: string, sessionId: string) {
  if (!projectDir) {
    throw new Error('projectDir required for workspace initialization');
  }
  // ... proceed
}
```

### 第三層：環境衛士
**目的：**防止特定情況下的危險操作

```typescript
async function gitInit(directory: string) {
  // In tests, refuse git init outside temp directories
  if (process.env.NODE_ENV === 'test') {
    const normalized = normalize(resolve(directory));
    const tmpDir = normalize(resolve(tmpdir()));

    if (!normalized.startsWith(tmpDir)) {
      throw new Error(
        `Refusing git init outside temp dir during tests: ${directory}`
      );
    }
  }
  // ... proceed
}
```

### 第 4 層：調試儀器
**目的：** 捕獲取證上下文

```typescript
async function gitInit(directory: string) {
  const stack = new Error().stack;
  logger.debug('About to git init', {
    directory,
    cwd: process.cwd(),
    stack,
  });
  // ... proceed
}
```

## 應用模式

當您發現錯誤時：

1. **追蹤資料流** - 不良值源自何處？哪裡用的？
2. **映射所有檢查點** - 列出數據經過的每個點
3. **在每一層添加驗證** - 入口、業務、環境、調試
4. **測試每一層** - 嘗試繞過第 1 層，驗證第 2 層捕獲它

## 會話示例

錯誤：空`projectDir`造成的`git init`在原始碼中

**資料流：**
1. 測試設置 → 空字符串
2. `Project.create(name, '')`
3. `WorkspaceManager.createWorkspace('')`
4. `git init`跑進`process.cwd()`

**新增了四層：**
- 第 1 層：`Project.create()`驗證不為空/存在/可寫
- 第 2 層：`WorkspaceManager`驗證projectDir不為空
- 第 3 層：`WorktreeManager`在測試中拒絕 tmpdir 之外的 git init
- 第4層：git init之前的追蹤堆疊日誌記錄

**結果：** 所有 1847 個測試均通過，錯誤無法重現

## 關鍵見解

所有四層都是必要的。在測試過程中，每一層都會發現其他層錯過的錯誤：
- 不同的程式碼路徑繞過了條目驗證
- 模擬繞過業務邏輯檢查
- 不同平臺上的邊緣情況需要環境衛士
- 調試日誌記錄發現結構性濫用

**不要停在一個驗證點。 ** 在每一層添加檢查。
