# OpenCode 的超能力

使用 [OpenCode.ai](https://opencode.ai). 超能力的完整指南

## 快速安裝

告訴 OpenCode：

```
Clone https://github.com/obra/superpowers to ~/.config/opencode/superpowers, then create directory ~/.config/opencode/plugins, then symlink ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js to ~/.config/opencode/plugins/superpowers.js, then symlink ~/.config/opencode/superpowers/skills to ~/.config/opencode/skills/superpowers, then restart opencode.
```

## 手動安裝

### 先決條件

- [OpenCode.ai]（https://opencode.ai)已安裝
- 已安裝 Git

### macOS/Linux

```bash
# 1. Install Superpowers (or update existing)
if [ -d ~/.config/opencode/superpowers ]; then
  cd ~/.config/opencode/superpowers && git pull
else
  git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers
fi

# 2. Create directories
mkdir -p ~/.config/opencode/plugins ~/.config/opencode/skills

# 3. Remove old symlinks/directories if they exist
rm -f ~/.config/opencode/plugins/superpowers.js
rm -rf ~/.config/opencode/skills/superpowers

# 4. Create symlinks
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers

# 5. Restart OpenCode
```

#### 驗證安裝

```bash
ls -l ~/.config/opencode/plugins/superpowers.js
ls -l ~/.config/opencode/skills/superpowers
```

兩者都應該顯示指向 superpowers 目錄的符號鏈接。

### 視窗

**先決條件：**
- 已安裝 Git
- 啟用 **開發人員模式** 或 **管理員權限**
  - Windows 10：設置→更新和安全→針對開發人員
  - Windows 11：設定→系統→開發人員

在下面選擇您的 shell： [命令提示符](#command-prompt) | [電源外殼](#powershell) | [git重擊](#git-bash)

#### 命令提示符

以管理員身份運行，或啟用開發人員模式：

```cmd
:: 1. Install Superpowers
git clone https://github.com/obra/superpowers.git "%USERPROFILE%\.config\opencode\superpowers"

:: 2. Create directories
mkdir "%USERPROFILE%\.config\opencode\plugins" 2>nul
mkdir "%USERPROFILE%\.config\opencode\skills" 2>nul

:: 3. Remove existing links (safe for reinstalls)
del "%USERPROFILE%\.config\opencode\plugins\superpowers.js" 2>nul
rmdir "%USERPROFILE%\.config\opencode\skills\superpowers" 2>nul

:: 4. Create plugin symlink (requires Developer Mode or Admin)
mklink "%USERPROFILE%\.config\opencode\plugins\superpowers.js" "%USERPROFILE%\.config\opencode\superpowers\.opencode\plugins\superpowers.js"

:: 5. Create skills junction (works without special privileges)
mklink /J "%USERPROFILE%\.config\opencode\skills\superpowers" "%USERPROFILE%\.config\opencode\superpowers\skills"

:: 6. Restart OpenCode
```

#### 電源外殼

以管理員身份運行，或啟用開發人員模式：

```powershell
# 1. Install Superpowers
git clone https://github.com/obra/superpowers.git "$env:USERPROFILE\.config\opencode\superpowers"

# 2. Create directories
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\plugins"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.config\opencode\skills"

# 3. Remove existing links (safe for reinstalls)
Remove-Item "$env:USERPROFILE\.config\opencode\plugins\superpowers.js" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:USERPROFILE\.config\opencode\skills\superpowers" -Force -ErrorAction SilentlyContinue

# 4. Create plugin symlink (requires Developer Mode or Admin)
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.config\opencode\plugins\superpowers.js" -Target "$env:USERPROFILE\.config\opencode\superpowers\.opencode\plugins\superpowers.js"

# 5. Create skills junction (works without special privileges)
New-Item -ItemType Junction -Path "$env:USERPROFILE\.config\opencode\skills\superpowers" -Target "$env:USERPROFILE\.config\opencode\superpowers\skills"

# 6. Restart OpenCode
```

#### git 重擊

注意：Git Bash 是原生的`ln`命令複製文件而不是創建符號鏈接。使用`cmd //c mklink`相反（`//c`Git Bash 文法是`/c`).

```bash
# 1. Install Superpowers
git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers

# 2. Create directories
mkdir -p ~/.config/opencode/plugins ~/.config/opencode/skills

# 3. Remove existing links (safe for reinstalls)
rm -f ~/.config/opencode/plugins/superpowers.js 2>/dev/null
rm -rf ~/.config/opencode/skills/superpowers 2>/dev/null

# 4. Create plugin symlink (requires Developer Mode or Admin)
cmd //c "mklink \"$(cygpath -w ~/.config/opencode/plugins/superpowers.js)\" \"$(cygpath -w ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js)\""

# 5. Create skills junction (works without special privileges)
cmd //c "mklink /J \"$(cygpath -w ~/.config/opencode/skills/superpowers)\" \"$(cygpath -w ~/.config/opencode/superpowers/skills)\""

# 6. Restart OpenCode
```

#### WSL 用戶

如果在 WSL 中執行 OpenCode，請改用 [macOS/Linux](#macos--linux) 指令。

#### 驗證安裝

**命令提示字元：**
```cmd
dir /AL "%USERPROFILE%\.config\opencode\plugins"
dir /AL "%USERPROFILE%\.config\opencode\skills"
```

**PowerShell：**
```powershell
Get-ChildItem "$env:USERPROFILE\.config\opencode\plugins" | Where-Object { $_.LinkType }
Get-ChildItem "$env:USERPROFILE\.config\opencode\skills" | Where-Object { $_.LinkType }
```

尋找`<SYMLINK>`或者`<JUNCTION>`在輸出中。

#### Windows 故障排除

**“您沒有足夠的權限”錯誤：**
- 在 Windows 設置中啟用開發人員模式，或者
- 右鍵單擊您的終端機→“以管理員身份運行”

**“當文件已存在時無法創建該文件”：**
- 首先運行刪除命令（步驟 3），然後重試

**git 克隆後符號連結不起作用：**
- 跑步`git config --global core.symlinks true`並重新克隆

## 用法

### 尋找技能

使用 OpenCode 的原生`skill`列出所有可用技能的工具：

```
use skill tool to list skills
```

### 載入技能

使用 OpenCode 的原生`skill`加載特定技能的工具：

```
use skill tool to load superpowers/brainstorming
```

### 個人技能

創造你自己的技能`~/.config/opencode/skills/`:

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

創造`~/.config/opencode/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### 專案技能

在 OpenCode 項目中創建特定於項目的技能：

```bash
# In your OpenCode project
mkdir -p .opencode/skills/my-project-skill
```

創造`.opencode/skills/my-project-skill/SKILL.md`:

```markdown
---
name: my-project-skill
description: Use when [condition] - [what it does]
---

# My Project Skill

[Your skill content here]
```

## 技能地點

OpenCode 從以下位置發現技能：

1. **專案技能**（`.opencode/skills/`) - 最高優先權
2. **個人技能**（`~/.config/opencode/skills/`)
3. **超能力技能** (`~/.config/opencode/skills/superpowers/`) - 通過符號鏈接

## 特徵

### 自動上下文注入

該插件透過以下方式自動注入超能力上下文`experimental.chat.system.transform`鉤。這會在每次請求時將“使用超能力”技能內容添加到系統提示中。

### 本土技能整合

Superpowers 使用 OpenCode 的原生`skill`技能發現和載入的工具。技能被符號連結到`~/.config/opencode/skills/superpowers/`因此它們會與您的個人和項目技能一起出現。

### 工具映射

為 Claude Code 編寫的技能會自動適應 OpenCode。引導程序提供映射指令：

- `TodoWrite` → `update_plan`
- `Task`帶有子代理程式 → OpenCode 的`@mention`系統
- `Skill`工具 → OpenCode 原生`skill`工具
- 文件操作 → 原生 OpenCode 工具

## 建築學

### 插件結構

**地點：**`~/.config/opencode/superpowers/.opencode/plugins/superpowers.js`

**成分：**
- `experimental.chat.system.transform`用於引導注入的鉤子
- 讀取並註入“使用超能力”技能內容

### 技能

**地點：**`~/.config/opencode/skills/superpowers/`（符號鏈接到`~/.config/opencode/superpowers/skills/`)

技能是由 OpenCode 的本機技能係統發現的。每個技能都有一個`SKILL.md`帶有 YAML frontmatter 的檔案。

## 更新中

```bash
cd ~/.config/opencode/superpowers
git pull
```

重新啟動 OpenCode 以載入更新。

## 故障排除

### 插件未加載

1. 檢查插件是否存在：`ls ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js`
2. 檢查符號連結/連接：`ls -l ~/.config/opencode/plugins/`(macOS/Linux) 或`dir /AL %USERPROFILE%\.config\opencode\plugins`（視窗）
3. 檢查 OpenCode 日誌：`opencode run "test" --print-logs --log-level DEBUG`
4. 在日誌中尋找插件載入訊息

### 未找到技能

1. 驗證技能符號鏈接：`ls -l ~/.config/opencode/skills/superpowers`（應指向超能力/技能/）
2. 使用 OpenCode 的`skill`列出可用技能的工具
3. 檢查技能結構：每個技能都需要一個`SKILL.md`具有有效 frontmatter 的文件

### Windows：找不到模組錯誤

如果你看到`Cannot find module`Windows 上的錯誤：
- **原因：** Git Bash`ln -sf`複製文件而不是創建符號鏈接
- **修復：** 使用`mklink /J`改為目錄連接（請參閱 Windows 安裝步驟）

### 引導程序未出現

1. 驗證 using-superpowers 技能是否存在：`ls ~/.config/opencode/superpowers/skills/using-superpowers/SKILL.md`
2. 檢查 OpenCode 版本支持`experimental.chat.system.transform`鉤
3. 插件更改後重新啟動 OpenCode

## 尋求協助

- 報告問題：https://github.com/obra/superpowers/issues
- 主要文檔：https://github.com/obra/superpowers
- OpenCode 文件：https://opencode.ai/docs/

## 測試

驗證您的安裝：

```bash
# Check plugin loads
opencode run --print-logs "hello" 2>&1 | grep -i superpowers

# Check skills are discoverable
opencode run "use skill tool to list all skills" 2>&1 | grep -i superpowers

# Check bootstrap injection
opencode run "what superpowers do you have?"
```

代理人應該提到擁有超能力，並能夠列出以下技能：`superpowers/`.
