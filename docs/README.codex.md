# Codex 的超能力

通過本機技能發現將 Superpowers 與 OpenAI Codex 結合使用的指南。

## 快速安裝

告訴法典：

```
Fetch and follow instructions from https://raw.githubusercontent.com/obra/superpowers/refs/heads/main/.codex/INSTALL.md
```

## 手動安裝

### 先決條件

- OpenAI Codex CLI
- git

### 步驟

1. 克隆存儲庫：
   ```bash
   git clone https://github.com/obra/superpowers.git ~/.codex/superpowers
   ```

2. 創建技能符號鏈接：
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
   ```

3. 重新啟動法典。

### 視窗

使用連接而不是符號連結（無​​需開發人員模式即可運作）：

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
cmd /c mklink /J "$env:USERPROFILE\.agents\skills\superpowers" "$env:USERPROFILE\.codex\superpowers\skills"
```

## 它是如何運作的

Codex 擁有原生技能發現——它會掃描`~/.agents/skills/`啟動時，解析SKILL.md frontmatter，並按需加載技能。超能力技能通過單個符號鏈接可見：

```
~/.agents/skills/superpowers/ → ~/.codex/superpowers/skills/
```

這`using-superpowers`技能會自動發現並強制執行技能使用規則——無需額外配置。

## 用法

技能是自動發現的。 Codex 在以下情況下激活它們：
- 您提到了一項技能的名稱（e.g.，“使用頭腦風暴”）
- 任務與技能描述相匹配
- 這`using-superpowers`技能指示法典使用一項

### 個人技能

創造你自己的技能`~/.agents/skills/`:

```bash
mkdir -p ~/.agents/skills/my-skill
```

創造`~/.agents/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

這`description`欄位是 Codex 決定何時自動啟動技能的方式——將其寫為明確的觸發條件。

## 更新中

```bash
cd ~/.codex/superpowers && git pull
```

技能通過符號鏈接立即更新。

## 解除安裝

```bash
rm ~/.agents/skills/superpowers
```

**Windows（PowerShell）：**
```powershell
Remove-Item "$env:USERPROFILE\.agents\skills\superpowers"
```

（可選）刪除克隆：`rm -rf ~/.codex/superpowers`（視窗：`Remove-Item -Recurse -Force "$env:USERPROFILE\.codex\superpowers"`).

## 故障排除

### 技能不顯示

1. 驗證符號連結：`ls -la ~/.agents/skills/superpowers`
2. 檢查技能是否存在：`ls ~/.codex/superpowers/skills`
3. 重新啟動 Codex — 技能在啟動時被發現

### Windows 連接問題

連接點通常無需特殊許可即可工作。如果創建失敗，請嘗試以管理員身份運行 PowerShell。

## 尋求協助

- 報告問題：https://github.com/obra/superpowers/issues
- 主要文檔：https://github.com/obra/superpowers
