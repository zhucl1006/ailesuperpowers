# 在 OpenCode 安裝 Superpowers

## 先決條件

- 已安裝 [OpenCode.ai](https://opencode.ai)
- 已安裝 Git

## 安裝步驟

### 1) Clone Superpowers

```bash
git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers
```

### 2) 註冊外掛

建立符號連結，讓 OpenCode 載入外掛：

```bash
mkdir -p ~/.config/opencode/plugins
rm -f ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
```

### 3) 建立 skills 符號連結

建立符號連結，讓 OpenCode 原生 `skill` 工具發現 superpowers skills：

```bash
mkdir -p ~/.config/opencode/skills
rm -rf ~/.config/opencode/skills/superpowers
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers
```

### 4) 重新啟動 OpenCode

重啟後，外掛會自動注入 superpowers 啟動上下文。  
可用「你有 superpowers 嗎？」快速驗證。

## 使用方式

### 列出技能

使用 OpenCode 原生 `skill` 工具：

```
use skill tool to list skills
```

### 載入技能

```
use skill tool to load superpowers/aile-requirement-analysis
```

### 個人技能

在 `~/.config/opencode/skills/` 建立個人技能：

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

建立 `~/.config/opencode/skills/my-skill/SKILL.md`：

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### 專案技能

可在專案內 `.opencode/skills/` 建立專案專用技能。  
**優先順序：** 專案技能 > 個人技能 > Superpowers 技能

## 更新

```bash
cd ~/.config/opencode/superpowers
git pull
```

## 疑難排解

### 外掛未載入

1. 檢查外掛符號連結：`ls -l ~/.config/opencode/plugins/superpowers.js`
2. 檢查來源是否存在：`ls ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js`
3. 查看 OpenCode 日誌是否有錯誤

### 找不到技能

1. 檢查 skills 符號連結：`ls -l ~/.config/opencode/skills/superpowers`
2. 確認它指向：`~/.config/opencode/superpowers/skills`
3. 用 `skill` 工具列出已發現技能

### 工具映射

當技能文檔引用 Claude Code 工具時：

- `TodoWrite` → `update_plan`
- `Task`（含子代理）→ `@mention` 語法
- `Skill` 工具 → OpenCode 原生 `skill` 工具
- 檔案操作 → 你的原生工具

## 取得協助

- 問題回報：https://github.com/obra/superpowers/issues
- 完整文檔：https://github.com/obra/superpowers/blob/main/docs/README.opencode.md
