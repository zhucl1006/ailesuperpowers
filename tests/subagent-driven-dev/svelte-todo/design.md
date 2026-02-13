# Svelte Todo 清單 - 設計

## 概述

使用 Svelte 構建的簡單待辦事項列表應用程序。支持使用 localStorage 持久性創建、完成和刪除待辦事項。

## 特徵

- 新增的待辦事項
- 將待辦事項標記為完成/不完整
- 刪除待辦事項
- 篩選條件：全部/活動/已完成
- 清除所有已完成的待辦事項
- 儲存到本地存儲
- 顯示剩餘項目數

## 使用者介面

```
┌─────────────────────────────────────────┐
│  Svelte Todos                           │
├─────────────────────────────────────────┤
│  [________________________] [Add]       │
├─────────────────────────────────────────┤
│  [ ] Buy groceries                  [x] │
│  [✓] Walk the dog                   [x] │
│  [ ] Write code                     [x] │
├─────────────────────────────────────────┤
│  2 items left                           │
│  [All] [Active] [Completed]  [Clear ✓]  │
└─────────────────────────────────────────┘
```

## 成分

```
src/
  App.svelte           # Main app, state management
  lib/
    TodoInput.svelte   # Text input + Add button
    TodoList.svelte    # List container
    TodoItem.svelte    # Single todo with checkbox, text, delete
    FilterBar.svelte   # Filter buttons + clear completed
    store.ts           # Svelte store for todos
    storage.ts         # localStorage persistence
```

## 資料模型

```typescript
interface Todo {
  id: string;        // UUID
  text: string;      // Todo text
  completed: boolean;
}

type Filter = 'all' | 'active' | 'completed';
```

## 驗收標準

1. 可以透過鍵入並按 Enter 或按一下「新增」來新增待辦事項
2. 可以通過單擊複選框來切換待辦事項完成情況
3. 可以透過點擊 X 按鈕刪除待辦事項
4. 篩選按鈕顯示待辦事項的正確子集
5. “剩餘 X 項”顯示未完成的待辦事項的數量
6. “清除已完成”刪除所有已完成的待辦事項
7. 待辦事項在頁面刷新後保持不變（localStorage）
8. 空狀態顯示有用的消息
9. 所有測試均通過
