# 在 Codex 安裝 Superpowers

透過原生技能發現機制，在 Codex 中啟用 Superpowers。只需 clone 與符號連結即可。

## 先決條件

- Git

## 安裝

1. **Clone Superpowers 倉庫：**
   ```bash
   git clone https://github.com/obra/superpowers.git ~/.codex/superpowers
   ```

2. **建立技能符號連結：**
   ```bash
   mkdir -p ~/.agents/skills
   ln -s ~/.codex/superpowers/skills ~/.agents/skills/superpowers
   ```

   **Windows（PowerShell）：**
   ```powershell
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.agents\skills"
   cmd /c mklink /J "$env:USERPROFILE\.agents\skills\superpowers" "$env:USERPROFILE\.codex\superpowers\skills"
   ```

3. **重新啟動 Codex**（完整退出並重開 CLI），讓技能被重新掃描。

## 從舊版 bootstrap 遷移

若你在原生技能發現推出前就安裝過 Superpowers，需要：

1. **更新倉庫：**
   ```bash
   cd ~/.codex/superpowers && git pull
   ```

2. **建立技能符號連結**（如上第 2 步）作為新發現機制。

3. **移除 `~/.codex/AGENTS.md` 的舊 bootstrap 區塊**  
   凡是引用 `superpowers-codex bootstrap` 的內容都可刪除。

4. **重新啟動 Codex。**

## 驗證

```bash
ls -la ~/.agents/skills/superpowers
```

你應該會看到指向 superpowers skills 目錄的符號連結（Windows 為 junction）。

## 更新

```bash
cd ~/.codex/superpowers && git pull
```

透過符號連結，技能會立即更新。

## 解除安裝

```bash
rm ~/.agents/skills/superpowers
```

可選：刪除本機 clone `rm -rf ~/.codex/superpowers`。
