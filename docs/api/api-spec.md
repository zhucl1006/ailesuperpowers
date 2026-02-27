# 內部API規範

## 1.範圍

該專案目前**沒有外部 HTTP/REST API**。本文檔指定了整合和測試使用的內部文件級 API 合約。

## 2.JavaScript庫API（`lib/skills-core.js`)

### 2.1 `extractFrontmatter(filePath: string): { name: string, description: string }`

- 輸入：Markdown 技能文件的絕對或相對文件路徑
- 行為：解析類似 YAML 的 frontmatter 行`name`和`description`
- 失敗行為：出錯時返回空字符串

### 2.2 `findSkillsInDir(dir: string, sourceType: string, maxDepth = 3): SkillMeta[]`

```ts
type SkillMeta = {
  path: string;
  skillFile: string;
  name: string;
  description: string;
  sourceType: string;
};
```

- 遞迴發現`SKILL.md`文件
- 為每個結果添加標籤`sourceType`

### 2.3 `resolveSkillPath(skillName: string, superpowersDir?: string, personalDir?: string): Resolution | null`

```ts
type Resolution = {
  skillFile: string;
  sourceType: 'personal' | 'superpowers';
  skillPath: string;
};
```

- 支援命名空間強制：`superpowers:<name>`
- 默認解決順序：個人優先，然後超能力

### 2.4 `checkForUpdates(repoDir: string): boolean`

- 使用 git fetch + status 偵測本地分支是否落後於 origin
- 退貨`false`關於網路/git/超時

### 2.5 `stripFrontmatter(content: string): string`

- 刪除第一個 YAML frontmatter 區塊並返回內容正文

## 3. OpenCode插件合約（`.opencode/plugins/superpowers.js`)

### 3.1 入口點

```ts
export const SuperpowersPlugin = async ({ client, directory }) => PluginHooks;
```

### 3.2 提供鉤子

- `experimental.chat.system.transform`
  - 將引導上下文附加到`output.system`
  - 注入區塊包括：
    - `aile-using-superpowers`身體內容
    - 工具映射指導
    - 技能目錄指導

## 4. 克勞德胡克輸出合約（`hooks/session-start.sh`)

腳本必須輸出有效的 JSON，格式為：

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>...</EXTREMELY_IMPORTANT>"
  }
}
```

消費者依賴這種精確的密鑰結構。

## 5.命令墊片合約（`commands/*.md`)

每個命令文件必須：

1. 收錄 frontmatter 與`description`和`disable-model-invocation: true`
2. 包含將命令呼叫對應到目標技能的單一指令

## 6. 相容性保證

- 向後相容性是為技能前沿問題盡力而為（`name`, `description`)
- 路徑解析規則或啟動引導行為的重大變更必須記錄在`RELEASE-NOTES.md`

## 7. 超出範圍

- 外部公共 HTTP API
- 數據庫查詢接口
- 穩定的 semver 合約，用於超出記錄的鉤子 JSON 形狀的內部 shell 腳本輸出
