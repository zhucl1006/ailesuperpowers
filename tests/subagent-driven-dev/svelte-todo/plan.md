# Svelte Todo List - 實施計劃

執行此計劃使用`superpowers:aile-subagent-dev`技能。

## 情境

使用 Svelte 構建待辦事項列表應用程序。看`design.md`以獲得完整規格。

## 任務

### 任務 1：項目設置

使用Vite建立Svelte專案。

**做：**
- 跑步`npm create vite@latest . -- --template svelte-ts`
- 安裝依賴項`npm install`
- 驗證開發伺服器是否正常運作
- 清理App.svelte預設Vite模板內容

**核實：**
- `npm run dev`啟動服務器
- 應用程序顯示最小的“Svelte Todos”標題
- `npm run build`成功

---

### 任務 2：Todo 商店

創建用於待辦事項狀態管理的 Svelte 存儲。

**做：**
- 創造`src/lib/store.ts`
- 定義`Todo`帶有 id、文本、已完成的界面
- 使用初始空數組建立可寫入存儲
- 導出功能：`addTodo(text)`, `toggleTodo(id)`, `deleteTodo(id)`, `clearCompleted()`
- 創造`src/lib/store.test.ts`對每個功能進行測試

**核實：**
- 測試通過：`npm run test`（如果需要安裝vitest）

---

### 任務3：localStorage持久化

為待辦事項新增持久層。

**做：**
- 創造`src/lib/storage.ts`
- 實施`loadTodos(): Todo[]`和`saveTodos(todos: Todo[])`
- 優雅地處理 JSON 解析錯誤（傳回空數組）
- 與儲存整合：在初始化時加載，在更改時保存
- 添加加載/保存/錯誤處理測試

**核實：**
- 測試通過
- 手動測試：新增todo，刷新頁面，todo持續存在

---

### 任務 4：TodoInput 元件

建立用於新增待辦事項的輸入元件。

**做：**
- 創造`src/lib/TodoInput.svelte`
- 文字輸入綁定到本地狀態
- 新增按鈕調用`addTodo()`並清除輸入
- Enter 鍵也提交
- 輸入為空時禁用新增按鈕
- 新增組件測試

**核實：**
- 測試通過
- 組件呈現輸入和按鈕

---

### 任務 5：TodoItem 組件

創建單個待辦事項組件。

**做：**
- 創造`src/lib/TodoItem.svelte`
- 道具：`todo: Todo`
- 複選框切換完成（調用`toggleTodo`)
- 完成後帶有刪除線的文本
- 刪除按鈕 (X) 調用`deleteTodo`
- 新增組件測試

**核實：**
- 測試通過
- 元件渲染複選框、文字、刪除按鈕

---

### 任務 6：TodoList 組件

建立清單容器元件。

**做：**
- 創造`src/lib/TodoList.svelte`
- 道具：`todos: Todo[]`
- 為每個待辦事項呈現 TodoItem
- 空時顯示“尚無待辦事項”
- 新增組件測試

**核實：**
- 測試通過
- 元件呈現 TodoItems 列表

---

### 任務 7：FilterBar 元件

創建過濾器和狀態欄組件。

**做：**
- 創造`src/lib/FilterBar.svelte`
- 道具：`todos: Todo[]`, `filter: Filter`, `onFilterChange: (f: Filter) => void`
- 顯示數量：「剩餘 X 件物品」（數量不完整）
- 三個過濾器按鈕：全部、活動、已完成
- 有源濾波器在視覺上突出顯示
- “清除已完成”按鈕（沒有完成的待辦事項時隱藏）
- 新增組件測試

**核實：**
- 測試通過
- 組件渲染計數、過濾器、清除按鈕

---

### 任務 8：應用程序集成

將App.svelte 中的所有組件連接在一起。

**做：**
- 導入所有組件並存儲
- 添加過濾器狀態（默認：“全部”）
- 根據過濾器狀態計算過濾後的待辦事項
- 渲染：標題、TodoInput、TodoList、FilterBar
- 將適當的 props 傳遞給每個組件

**核實：**
- 應用程序渲染所有組件
- 添加待辦事項工作
- 切換作品
- 刪除作品

---

### 任務 9：過濾器功能

確保過濾端對端工作。

**做：**
- 驗證過濾器按鈕更改顯示的待辦事項
- “all”顯示所有待辦事項
- “active”僅顯示不完整的待辦事項
- 「已完成」僅顯示已完成的待辦事項
- 清除已完成刪除已完成的待辦事項並根據需要重置過濾器
- 添加集成測試

**核實：**
- 過濾器測試通過
- 手動驗證所有過濾器狀態

---

### 任務 10：造型與潤飾

添加 CSS 樣式以提高可用性。

**做：**
- 設置應用程序的樣式以匹配設計模型
- 已完成的待辦事項有刪除線和柔和的顏色
- 活動過濾器按鈕反白顯示
- 輸入具有焦點樣式
- 刪除按鈕出現在懸停時（或始終在移動設備上）
- 響應式佈局

**核實：**
- 應用程式在視覺上可用
- 樣式不會破壞功能

---

### 任務 11：端到端測試

為完整的使用者流程新增 Playwright 測試。

**做：**
- 安裝劇作家：`npm init playwright@latest`
- 創造`tests/todo.spec.ts`
- 測試流程：
  - 新增待辦事項
  - 完成待辦事項
  - 刪除待辦事項
  - 過濾待辦事項
  - 清除完成
  - 持久化（新增、重新載入、驗證）

**核實：**
- `npx playwright test`透過

---

### 任務 12：自述文件

記錄項目。

**做：**
- 創造`README.md`和：
  - 項目描述
  - 設定:`npm install`
  - 發展：`npm run dev`
  - 測試：`npm test`和`npx playwright test`
  - 建造：`npm run build`

**核實：**
- README 準確描述了該項目
- 指導工作
