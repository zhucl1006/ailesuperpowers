# 模組：平臺集成

## 1.範圍

本模組介紹如何將 Superpowers 整合到每個受支援的編碼代理平臺中。

- 克勞德代碼：`.claude-plugin/`, `hooks/`
- 法典：`.codex/INSTALL.md`, `docs/README.codex.md`
- 打開代碼：`.opencode/plugins/superpowers.js`, `.opencode/INSTALL.md`, `docs/README.opencode.md`
- 命令墊片：`commands/*.md`

## 2.克勞德代碼集成

### 機制

- 插件元數據位於`.claude-plugin/plugin.json`
- 會話引導上下文透過注入`hooks/session-start.sh`
- 鉤子註冊配置在`hooks/hooks.json`

### 目的

- 確保`using-superpowers`指導在會話開始時加載
- 檢測到遺留技能位置時提供遷移警告

## 3. 法典整合

### 機制

- 使用本機技能發現（檔案系統符號連結/連接模型）
- 安裝說明記錄在`.codex/INSTALL.md`和`docs/README.codex.md`

### 目的

- 透過依賴 Codex 原生發現來保持運行時輕量級
- 消除先前引導 CLI 的複雜性

## 4. 開放式程式碼集成

### 機制

- 插件入口點：`.opencode/plugins/superpowers.js`
- 用途`experimental.chat.system.transform`附加引導內容
- 讀`skills/using-superpowers/SKILL.md`直接並註入工具映射指導

### 目的

- 提供一致的啟動上下文，沒有代理重置副作用
- 與 OpenCode 原生技能發現佈局和插件系統保持一致

## 5. 命令墊片

文件下`commands/`提供強制特定超能力技能的簡短指令別名：

- `commands/brainstorm.md`
- `commands/write-plan.md`
- `commands/execute-plan.md`
- `commands/aile-requirement-intake.md`
- `commands/aile-write-plan.md`
- `commands/aile-pencil-design.md`
- `commands/aile-tdd.md`
- `commands/aile-subagent-dev.md`
- `commands/aile-code-review.md`
- `commands/aile-delivery-report.md`

每個命令使用`disable-model-invocation: true`並指示直接技能調用。

## 6. 兼容性說明

- Windows 行為需要掛鉤和安裝指南中的特定修復（請參閱`RELEASE-NOTES.md`)
- 特定於平臺的安裝步驟必須與發行說明保持同步

## 7. 改變指導

對於任何集成更改：

1. 更新平臺文檔`docs/README.*.md`
2. 更新遷移說明`RELEASE-NOTES.md`當行為被破壞時
3. 重新運行相關測試（`tests/opencode/*`, `tests/claude-code/*`)
