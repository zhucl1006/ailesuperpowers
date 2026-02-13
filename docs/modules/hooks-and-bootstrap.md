# 模塊：Hooks 和 Bootstrap

## 1.範圍

- 克勞德引導掛鉤配置：`hooks/hooks.json`
- Claude 會話引導腳本：`hooks/session-start.sh`
- 舊包裝參考：`hooks/run-hook.cmd`（保留歷史相容性註釋）

## 2、責任

提供啟動時上下文注入，以便代理始終接收`using-superpowers`會議開始時的指導。

## 3. 運行時行為

1. Claude SessionStart 事件匹配`startup|resume|clear|compact`觸發鉤子
2. `session-start.sh`讀`skills/using-superpowers/SKILL.md`
3. 腳本 JSON 轉義內容並發出 Claude 插件運行時所需的鉤子負載格式
4. 如果遺留路徑`~/.config/superpowers/skills`存在，腳本添加遷移警告文本

## 4. 輸出合約

此鉤子輸出 JSON：

- `hookSpecificOutput.hookEventName = SessionStart`
- `hookSpecificOutput.additionalContext = <EXTREMELY_IMPORTANT>...</EXTREMELY_IMPORTANT>`

該合約必須保持穩定，以避免無提示引導失敗。

## 5. 性能和兼容性說明

- JSON 轉義使用參數替換來獲得更好的性能
- Hook 非同步運作（`"async": true`）以避免發行說明中記錄的 Windows 終端凍結情況
- `run-hook.cmd`在當前主路徑中已棄用，但保留以供參考

## 六、風險

- 無效的 JSON 發射破壞了引導上下文注入
- Shell 可移植性回歸可以阻止特定作業系統/Shell 組合上的啟動行為

## 7. 驗證

- 手動檢查 shell 腳本編輯的語法
- 運行克勞德相關的測試：`tests/claude-code/run-skill-tests.sh`
- 更改掛鉤呼叫樣式時重新驗證特定於 Windows 的行為
