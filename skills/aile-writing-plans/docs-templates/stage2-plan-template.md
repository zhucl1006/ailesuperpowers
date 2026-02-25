# 階段 2：實施計劃模板（執行版）

> 適用場景：階段 2 已完成 `analysis.md`，本文件僅用於執行落地與過程追蹤。

**Story Key:** {Story-Key}
**計劃日期:** YYYY-MM-DD
**負責人:** {Owner}
**目前狀態:** 草稿 / 已批准 / 進行中 / 已完成 / 已取消

**關聯分析報告（必填）:** `docs/plans/{Story-Key}/analysis.md`
**關聯 Jira Story（必填）:** `{Story-Key}`

---

## 0. 使用邊界與規則

- 本模板**不再重複**需求分析、架構設計、元件設計（統一以 `analysis.md` 為準）。
- 僅記錄：實施任務、整合測試、文件更新、執行記錄。
- 單任務建議粒度：2-5 分鐘，可獨立驗證。
- 每個實施任務必須包含 TDD 證據：RED → GREEN → REFACTOR。
- 狀態統一：待開始 / 進行中 / 阻塞 / 已完成 / 已取消。

---

## 1. 實施任務

### 1.1 前置檢查

- [ ] `analysis.md` 已評審通過
- [ ] 本地依賴與環境可用
- [ ] 測試命令可執行
- [ ] 任務拆分已覆蓋全部 AC

### 1.2 任務看板（總覽）

| 任務 ID | 任務名稱 | 類型 | 負責人 | 狀態 | 依賴 | 目標檔案 | 驗證命令 |
|--------|----------|------|--------|------|------|----------|----------|
| T1 | [示例：新增驗證碼發送介面] | 實作 | {Owner} | 待開始 | 無 | `src/...` | `pytest tests/... -k ... -v` |
| T2 | [示例：補充輸入校驗] | 實作 | {Owner} | 待開始 | T1 | `src/...` | `pytest tests/... -k ... -v` |
| T3 | [示例：重構重複邏輯] | 重構 | {Owner} | 待開始 | T1,T2 | `src/...` | `pytest tests/... -k ... -v` |

### 1.3 任務結構模板（逐任務複製）

#### Task N: [Component Name]

- **關聯 AC：** AC-xx
- **負責人：** {Owner}
- **狀態：** 待開始 / 進行中 / 阻塞 / 已完成 / 已取消
- **開始時間：** YYYY-MM-DD HH:mm
- **完成時間：** YYYY-MM-DD HH:mm
- **阻塞原因：** 無 / {說明}

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input_data)
    assert result == expected_output
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`  
Expected: FAIL with `"function not defined"`

**Step 3: Write minimal implementation**

```python
def function(input_data):
    return expected_output
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`  
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

**完成定義（DoD）：**
- [ ] 關聯 AC 已覆蓋
- [ ] 單元測試通過
- [ ] 無新增 lint/type 錯誤
- [ ] 程式碼變更範圍符合 YAGNI（無無關修改）

---

## 2. 整合測試

### 2.1 整合場景清單

| IT 編號 | 關聯 AC | 場景描述 | 前置條件 | 執行人 | 狀態 | 結果 |
|--------|---------|----------|----------|--------|------|------|
| IT-01 | AC-01,AC-02 | [示例：發送並校驗驗證碼完整鏈路] | 測試信箱可用 | {Owner} | 待開始 | 未執行 |
| IT-02 | AC-03 | [示例：錯誤驗證碼提示] | 已發送驗證碼 | {Owner} | 待開始 | 未執行 |

### 2.2 整合測試記錄模板（逐場景複製）

#### 整合測試 {ITx}：{場景名稱}

- **關聯 AC：**
- **前置條件：**
- **步驟：**
  1. 
  2. 
  3. 
- **預期結果：**
- **實際結果：** 通過 / 失敗

**執行命令：**
```bash
# 示例
pytest tests/integration/test_xxx.py -v
```

**失敗處理：**
- 根因：
- 修復任務：Tx
- 回歸結果：

---

## 3. 文件更新

| 文件 ID | 文件路徑 | 更新內容 | 觸發任務/測試 | 負責人 | 狀態 |
|--------|----------|----------|---------------|--------|------|
| D1 | `docs/modules/...` | [示例：補充設定說明] | T1 | {Owner} | 待開始 |
| D2 | `docs/changelog.md` | [示例：記錄功能變更] | IT-01 | {Owner} | 待開始 |

### 文件更新完成標準

- [ ] 對外行為變更已寫入使用文件
- [ ] 設定或介面變更已同步到模組文件
- [ ] 驗收/測試結論已同步到計劃或 Jira

---

## 4. 執行記錄

> 記錄所有關鍵狀態變化、阻塞與決策；用於稽核與交接。

| 時間 | 類型 | 關聯項 | 變更內容 | 操作人 | 結果/後續動作 |
|------|------|--------|----------|--------|---------------|
| YYYY-MM-DD HH:mm | 狀態變更 | T1 | 待開始 -> 進行中 | {Owner} | 開始 RED |
| YYYY-MM-DD HH:mm | 測試結果 | IT-01 | 首次執行失敗 | {Owner} | 新建修復任務 T4 |
| YYYY-MM-DD HH:mm | 決策 | D1 | 文件拆分章節 | {Owner} | 待評審 |

### 阻塞清單（可選）

| 阻塞 ID | 關聯項 | 問題描述 | 影響 | Owner | 計劃解除時間 | 目前狀態 |
|---------|--------|----------|------|-------|--------------|----------|
| B1 | T2 | [示例：依賴介面未就緒] | 無法進入 GREEN | {Owner} | YYYY-MM-DD | 開啟 |

---

## 5. 收尾檢查（執行完成前）

- [ ] 所有實施任務狀態為「已完成/已取消」
- [ ] 所有整合測試已執行並有結論
- [ ] 文件更新完成且可追溯
- [ ] 執行記錄完整（含失敗與回歸）
- [ ] Jira 狀態與本文件一致
