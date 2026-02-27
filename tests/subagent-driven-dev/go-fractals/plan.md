# Go Fractals CLI - 實施計劃

執行此計劃使用`superpowers:aile-subagent-dev`技能。

## 情境

構建一個生成 ASCII 分形的 CLI 工具。看`design.md`以獲得完整規格。

## 任務

### 任務 1：項目設置

建立 Go 模組和目錄結構。

**做：**
- 初始化`go.mod`帶有模塊名稱`github.com/superpowers-test/fractals`
- 建立目錄結構：`cmd/fractals/`, `internal/sierpinski/`, `internal/mandelbrot/`, `internal/cli/`
- 創建最小`cmd/fractals/main.go`列印“fractals cli”
- 添加`github.com/spf13/cobra`依賴性

**核實：**
- `go build ./cmd/fractals`成功
- `./fractals`列印“分形 cli”

---

### 任務 2：帶有幫助的 CLI 框架

設置帶有幫助輸出的 Cobra root 命令。

**做：**
- 創造`internal/cli/root.go`使用 root 命令
- 配置顯示可用子命令的說明文字
- 將 root 命令連接到`main.go`

**核實：**
- `./fractals --help`顯示“sierpinski”和“mandelbrot”列為可用指令的用法
- `./fractals`（無參數）顯示幫助

---

### 任務3：謝爾賓斯基算法

實現謝爾賓斯基三角形生成算法。

**做：**
- 創造`internal/sierpinski/sierpinski.go`
- 實施`Generate(size, depth int, char rune) []string`返回三角形的線
- 使用遞歸中點細分演算法
- 創造`internal/sierpinski/sierpinski_test.go`與測試：
  - 小三角形（大小 = 4，深度 = 2）與預期輸出匹配
  - Size=1 返回單個字符
  - 深度=0 返回填充三角形

**核實：**
- `go test ./internal/sierpinski/...`透過

---

### 任務 4：Sierpinski CLI 集成

將 Sierpinski 算法連接到 CLI 子命令。

**做：**
- 創造`internal/cli/sierpinski.go`和`sierpinski`子命令
- 添加標誌：`--size`（預設 32），`--depth`（預設 5），`--char`(預設 '*')
- 稱呼`sierpinski.Generate()`並將結果列印到標準輸出

**核實：**
- `./fractals sierpinski`輸出一個三角形
- `./fractals sierpinski --size 16 --depth 3`輸出較小的三角形
- `./fractals sierpinski --help`顯示標誌文檔

---

### 任務 5：Mandelbrot 算法

實現 Mandelbrot 集 ASCII 渲染器。

**做：**
- 創造`internal/mandelbrot/mandelbrot.go`
- 實施`Render(width, height, maxIter int, char string) []string`
- 將復平面區域（-2.5 到1.0 實數，-1.0 到1.0 虛數）映射到輸出尺寸
- 將迭代計數映射到字符漸變“.:-=+*#%@”（或單個字符，如果提供）
- 創造`internal/mandelbrot/mandelbrot_test.go`與測試：
  - 輸出尺寸符合要求的寬度/高度
  - 集合 (0,0) 內的已知點映射到最大迭代字符
  - 集合 (2,0) 之外的已知點映射到低迭代字符

**核實：**
- `go test ./internal/mandelbrot/...`透過

---

### 任務 6：Mandelbrot CLI 集成

將 Mandelbrot 算法連接到 CLI 子命令。

**做：**
- 創造`internal/cli/mandelbrot.go`和`mandelbrot`子命令
- 添加標誌：`--width`（默認 80），`--height`（預設 24），`--iterations`（預設 100），`--char`(預設 "")
- 稱呼`mandelbrot.Render()`並將結果列印到標準輸出

**核實：**
- `./fractals mandelbrot`輸出可識別的Mandelbrot集
- `./fractals mandelbrot --width 40 --height 12`輸出較小版本
- `./fractals mandelbrot --help`顯示標誌文檔

---

### 任務 7：字元集配置

確保`--char`flag 在兩個命令中一致工作。

**做：**
- 驗證謝爾賓斯基`--char`標誌將字元傳遞給演算法
- 對曼德布羅特來說，`--char`應該使用單個字符而不是漸變
- 新增自訂字元輸出的測試

**核實：**
- `./fractals sierpinski --char '#'`使用“#”字符
- `./fractals mandelbrot --char '.'`使用“.”對於所有填充點
- 測試通過

---

### 任務 8：輸入驗證和錯誤處理

新增對無效輸入的驗證。

**做：**
- Sierpinski：大小必須 > 0，深度必須 >= 0
- Mandelbrot：寬度/高度必須 > 0，迭代必須 > 0
- 針對無效輸入返回明確的錯誤消息
- 添加錯誤情況測試

**核實：**
- `./fractals sierpinski --size 0`列印錯誤，退出非零
- `./fractals mandelbrot --width -1`列印錯誤，退出非零
- 錯誤訊息清晰且有幫助

---

### 任務 9：整合測試

新增調用 CLI 的整合測試。

**做：**
- 創造`cmd/fractals/main_test.go`或者`test/integration_test.go`
- 測試這兩個命令的完整 CLI 調用
- 驗證輸出格式和退出程式碼
- 測試錯誤情況返回非零退出

**核實：**
- `go test ./...`通過所有測試，包括整合測試

---

### 任務 10：自述文件

文檔用法和示例。

**做：**
- 創造`README.md`和：
  - 項目描述
  - 安裝：`go install ./cmd/fractals`
  - 兩個命令的用法示例
  - 輸出示例（小樣本）

**核實：**
- 自述文件準確地描述了該工具
- README 中的示例確實有效
