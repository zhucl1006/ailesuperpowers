# Claude 代碼的跨平臺多語言掛鉤

Claude Code 外掛程式需要適用於 Windows、macOS 和 Linux 的掛鉤。本文檔解釋了使這成為可能的多語言包裝技術。

## 問題

Claude Code 透過系統預設的 shell 運行鉤子指令：
- **Windows**：CMD.exe
- **macOS/Linux**：bash 或 sh

這帶來了幾個挑戰：

1. **腳本執行**：Windows CMD無法執行`.sh`直接文件 - 它嘗試在文本編輯器中打開它們
2. **路徑格式**：Windows 使用反斜線 (`C:\path`), Unix 使用正斜槓 (`/path`)
3. **環境變量**：`$VAR`語法在 CMD 中不起作用
4. **不`bash`在 PATH** 中：即使安裝了 Git Bash，`bash`CMD 運行時不在 PATH 中

## 解決方案：多語言`.cmd`包裝紙

多語言腳本是同時適用於多種語言的有效語法。我們的包裝器在 CMD 和 bash 中都有效：

```cmd
: << 'CMDBLOCK'
@echo off
"C:\Program Files\Git\bin\bash.exe" -l -c "\"$(cygpath -u \"$CLAUDE_PLUGIN_ROOT\")/hooks/session-start.sh\""
exit /b
CMDBLOCK

# Unix shell runs from here
"${CLAUDE_PLUGIN_ROOT}/hooks/session-start.sh"
```

### 它是如何運作的

#### 在 Windows 上 (CMD.exe)

1. `: << 'CMDBLOCK'`- CMD 看到`:`作為標籤（例如`:label`）並忽略`<< 'CMDBLOCK'`
2. `@echo off`- 抑制命令回顯
3. bash.exe 命令運行時：
   - `-l`（登錄 shell）使用 Unix 實用程序獲取正確的 PATH
   - `cygpath -u`將 Windows 路徑轉換為 ​​Unix 格式（`C:\foo` → `/c/foo`)
4. `exit /b`- 退出批次腳本，在此處停止 CMD
5. 之後的一切`CMDBLOCK`CMD 永遠無法到達

#### 在 Unix 上（bash/sh）

1. `: << 'CMDBLOCK'` - `:`是一個空操作，`<< 'CMDBLOCK'`開始一個定界符
2. 一切直到`CMDBLOCK`被heredoc消耗（被忽略）
3. `# Unix shell runs from here`- 評論
4. 該腳本直接使用 Unix 路徑運行

## 文件結構

```
hooks/
├── hooks.json           # Points to the .cmd wrapper
├── session-start.cmd    # Polyglot wrapper (cross-platform entry point)
└── session-start.sh     # Actual hook logic (bash script)
```

### hooks.json

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/session-start.cmd\""
          }
        ]
      }
    ]
  }
}
```

注意：路徑必須加引號，因為`${CLAUDE_PLUGIN_ROOT}`在 Windows 上可能包含空格（e.g.,`C:\Program Files\...`).

## 要求

### 視窗
- **必須安裝 Windows 版 Git**（提供`bash.exe`和`cygpath`)
- 默認安裝路徑：`C:\Program Files\Git\bin\bash.exe`
- 如果Git安裝在其他地方，則包裝器需要修改

### Unix（macOS/Linux）
- 標準 bash 或 sh shell
- 這`.cmd`文件必須具有執行權限（`chmod +x`)

## 編寫跨平臺 Hook 腳本

你的實際鉤子邏輯在`.sh`文件。確保它可以在 Windows 上運行（透過 Git Bash）：

### 做：
- 盡可能使用純 bash 內建函數
- 使用`$(command)`而不是反引號
- 引用所有變數擴充：`"$VAR"`
- 使用`printf`或此處文檔用於輸出

### 避免：
- 可能不在 PATH 中的外部命令（sed、awk、grep）
- 如果您必須使用它們，它們可以在 Git Bash 中使用，但請確保設置了 PATH（使用`bash -l`)

### 範例：不使用 sed/awk 進行 JSON 轉義

而不是：
```bash
escaped=$(echo "$content" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')
```

使用純 bash：
```bash
escape_for_json() {
    local input="$1"
    local output=""
    local i char
    for (( i=0; i<${#input}; i++ )); do
        char="${input:$i:1}"
        case "$char" in
            $'\\') output+='\\' ;;
            '"') output+='\"' ;;
            $'\n') output+='\n' ;;
            $'\r') output+='\r' ;;
            $'\t') output+='\t' ;;
            *) output+="$char" ;;
        esac
    done
    printf '%s' "$output"
}
```

## 可重複使用的包裝圖案

對於具有多個鉤子的插件，您可以建立一個通用包裝器，將腳本名稱作為參數：

### run-hook.cmd
```cmd
: << 'CMDBLOCK'
@echo off
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_NAME=%~1"
"C:\Program Files\Git\bin\bash.exe" -l -c "cd \"$(cygpath -u \"%SCRIPT_DIR%\")\" && \"./%SCRIPT_NAME%\""
exit /b
CMDBLOCK

# Unix shell runs from here
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
SCRIPT_NAME="$1"
shift
"${SCRIPT_DIR}/${SCRIPT_NAME}" "$@"
```

### hooks.json 使用可重複使用包裝器
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" session-start.sh"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd\" validate-bash.sh"
          }
        ]
      }
    ]
  }
}
```

## 故障排除

### “bash 未被識別”
CMD 找不到 bash。包裝器使用完整路徑`C:\Program Files\Git\bin\bash.exe`。如果 Git 安裝在其他地方，請更新路徑。

### “cygpath：找不到指令”或“目錄名稱：找不到指令”
Bash 不以登入 shell 運作。確保`-l`使用標誌。

### 路徑有奇怪的地方`\/`在其中
`${CLAUDE_PLUGIN_ROOT}`擴展為以反斜線結尾的 Windows 路徑，然後`/hooks/...`被附加。使用`cygpath`轉換整個路徑。

### 腳本在文字編輯器中開啟而不是運行
hooks.json 直接指向`.sh`文件。指向`.cmd`包裝紙代替。

### 在終端機中工作但不能作為鉤子
Claude Code 可能會以不同的方式運行鉤子。通過模擬hook環境進行測試：
```powershell
$env:CLAUDE_PLUGIN_ROOT = "C:\path\to\plugin"
cmd /c "C:\path\to\plugin\hooks\session-start.cmd"
```

## 相關問題

- [人類學/克勞德代碼#9758](https://github.com/anthropics/claude-code/issues/9758) - .sh 腳本在 Windows 上的編輯器中打開
- [人類學/克勞德代碼#3417](https://github.com/anthropics/claude-code/issues/3417) - Hooks 在 Windows 上不起作用
- [人類學/克勞德代碼#6023](https://github.com/anthropics/claude-code/issues/6023) - CLAUDE_PROJECT_DIR 找不到
