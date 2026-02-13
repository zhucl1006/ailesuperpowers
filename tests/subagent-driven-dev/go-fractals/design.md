# Go 分形 CLI - 設計

## 概述

產生 ASCII 藝術分形的命令列工具。支援兩種具有可配置輸出的分形類型。

## 用法

```bash
# Sierpinski triangle
fractals sierpinski --size 32 --depth 5

# Mandelbrot set
fractals mandelbrot --width 80 --height 24 --iterations 100

# Custom character
fractals sierpinski --size 16 --char '#'

# Help
fractals --help
fractals sierpinski --help
```

## 命令

### `sierpinski`

使用遞歸細分生成謝爾賓斯基三角形。

標誌：
- `--size`（預設值：32）- 三角形底邊的寬度（以字元為單位）
- `--depth` (default: 5) - Recursion depth
- `--char`（默認值：'*'） - 用於填充點的字符

輸出：將三角形打印到標準輸出，每行一行。

### `mandelbrot`

Renders the Mandelbrot set as ASCII art. Maps iteration count to characters.

標誌：
- `--width`（默認值：80）- 以字符為單位的輸出寬度
- `--height` (default: 24) - Output height in characters
- `--iterations` (default: 100) - Maximum iterations for escape calculation
- `--char` (default: gradient) - Single character, or omit for gradient " .:-=+*#%@"

輸出：列印到標準輸出的矩形。

## 建築學

```
cmd/
  fractals/
    main.go           # Entry point, CLI setup
internal/
  sierpinski/
    sierpinski.go     # Algorithm
    sierpinski_test.go
  mandelbrot/
    mandelbrot.go     # Algorithm
    mandelbrot_test.go
  cli/
    root.go           # Root command, help
    sierpinski.go     # Sierpinski subcommand
    mandelbrot.go     # Mandelbrot subcommand
```

## 依賴關係

- 去1.21+
- `github.com/spf13/cobra`對於 CLI

## 驗收標準

1. `fractals --help`顯示用法
2. `fractals sierpinski`輸出一個可辨識的三角形
3. `fractals mandelbrot`輸出一個可識別的曼德爾布羅集
4. `--size`, `--width`, `--height`, `--depth`, `--iterations`旗幟工作
5. `--char`自訂輸出字符
6. 無效輸入會產生明確的錯誤訊息
7. 所有測試均通過
