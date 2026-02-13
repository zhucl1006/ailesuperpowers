# OpenCode 支援設計

**日期：** 2025-11-22
**作者：** 機器人和傑西
**狀態：** 設計完成，等待實施

## 概述

使用與現有 Codex 實作共享核心功能的本機 OpenCode 外掛程式架構來新增對 OpenCode.ai 的完整超級支援。

## 背景

OpenCode.ai 是類似 Claude Code 和 Codex 的編碼代理。先前將超能力移植到 OpenCode 的嘗試（PR #93、PR #116）使用的是檔案複製方法。此設計採用了不同的方法：使用 JavaScript/TypeScript 插件系統建立本機 OpenCode 插件，同時與 Codex 實作共用程式碼。

### 平臺之間的主要差異

- **Claude Code**：原生 Anthropic 插件系統 + 基於文件的技能
- **Codex**：無插件系統 → bootstrap markdown + CLI 腳本
- **OpenCode**：具有事件掛鉤和自定義工具 API 的 JavaScript/TypeScript 插件

### OpenCode的代理系統

- **主要代理**：構建（默認，完全訪問）和計劃（受限，只讀）
- **子代理**：一般（研究、搜索、多步驟任務）
- **呼叫**：由主要代理自動調度或手動`@mention`句法
- **配置**：自定義代理`opencode.json`或者`~/.config/opencode/agent/`

## 建築學

### 高層結構

1. **共享核心模塊** (`lib/skills-core.js`)
   - 常用技能發現與解析邏輯
   - 由 Codex 和 OpenCode 實作使用

2. **特定於平臺的包裝器**
   - 法典：CLI 腳本（`.codex/superpowers-codex`)
   - OpenCode：插件模塊（`.opencode/plugin/superpowers.js`)

3. **技能目錄**
   - 核：`~/.config/opencode/superpowers/skills/`（或安裝位置）
   - 個人的：`~/.config/opencode/skills/`（暗影核心技能）

### 程式碼重複使用策略

從中提取通用功能`.codex/superpowers-codex`進入共享模組：

```javascript
// lib/skills-core.js
module.exports = {
  extractFrontmatter(filePath),      // Parse name + description from YAML
  findSkillsInDir(dir, maxDepth),    // Recursive SKILL.md discovery
  findAllSkills(dirs),                // Scan multiple directories
  resolveSkillPath(skillName, dirs), // Handle shadowing (personal > core)
  checkForUpdates(repoDir)           // Git fetch/status check
};
```

### 技能前題格式

目前格式（無`when_to_use`場地）：

```yaml
---
name: skill-name
description: Use when [condition] - [what it does]; [additional context]
---
```

## OpenCode 外掛實現

### 客製化工具

**工具1：`use_skill`**

將特定技能的內容加載到對話中（相當於克勞德的技能工具）。

```javascript
{
  name: 'use_skill',
  description: 'Load and read a specific skill to guide your work',
  schema: z.object({
    skill_name: z.string().describe('Name of skill (e.g., "superpowers:brainstorming")')
  }),
  execute: async ({ skill_name }) => {
    const { skillPath, content, frontmatter } = resolveAndReadSkill(skill_name);
    const skillDir = path.dirname(skillPath);

    return `# ${frontmatter.name}
# ${frontmatter.description}
# Supporting tools and docs are in ${skillDir}
# ============================================

${content}`;
  }
}
```

**工具2：`find_skills`**

列出所有可用的技能和元數據。

```javascript
{
  name: 'find_skills',
  description: 'List all available skills',
  schema: z.object({}),
  execute: async () => {
    const skills = discoverAllSkills();
    return skills.map(s =>
      `${s.namespace}:${s.name}
  ${s.description}
  Directory: ${s.directory}
`).join('\n');
  }
}
```

### 會話啟動掛鉤

當新會話開始時（`session.started`事件）：

1. **注入使用超能力的內容**
   - 使用超能力技能的完整內容
   - 建立強制性工作流程

2. **自動運行find_skills**
   - 預先顯示可用技能的完整列表
   - 包括每個技能目錄

3. **注入工具映射說明**
   ```markdown
   **Tool Mapping for OpenCode:**
   When skills reference tools you don't have, substitute:
   - `TodoWrite` → `update_plan`
   - `Task` with subagents → Use OpenCode subagent system (@mention)
   - `Skill` tool → `use_skill` custom tool
   - Read, Write, Edit, Bash → Your native equivalents

   **Skill directories contain:**
   - Supporting scripts (run with bash)
   - Additional documentation (read with read tool)
   - Utilities specific to that skill
   ```

4. **檢查更新**（非阻塞）
   - 帶超時的快速 git fetch
   - 通知是否有可用更新

### 插件結構

```javascript
// .opencode/plugin/superpowers.js
const skillsCore = require('../../lib/skills-core');
const path = require('path');
const fs = require('fs');
const { z } = require('zod');

export const SuperpowersPlugin = async ({ client, directory, $ }) => {
  const superpowersDir = path.join(process.env.HOME, '.config/opencode/superpowers');
  const personalDir = path.join(process.env.HOME, '.config/opencode/skills');

  return {
    'session.started': async () => {
      const usingSuperpowers = await readSkill('using-superpowers');
      const skillsList = await findAllSkills();
      const toolMapping = getToolMappingInstructions();

      return {
        context: `${usingSuperpowers}\n\n${skillsList}\n\n${toolMapping}`
      };
    },

    tools: [
      {
        name: 'use_skill',
        description: 'Load and read a specific skill',
        schema: z.object({
          skill_name: z.string()
        }),
        execute: async ({ skill_name }) => {
          // Implementation using skillsCore
        }
      },
      {
        name: 'find_skills',
        description: 'List all available skills',
        schema: z.object({}),
        execute: async () => {
          // Implementation using skillsCore
        }
      }
    ]
  };
};
```

## 文件結構

```
superpowers/
├── lib/
│   └── skills-core.js           # NEW: Shared skill logic
├── .codex/
│   ├── superpowers-codex        # UPDATED: Use skills-core
│   ├── superpowers-bootstrap.md
│   └── INSTALL.md
├── .opencode/
│   ├── plugin/
│   │   └── superpowers.js       # NEW: OpenCode plugin
│   └── INSTALL.md               # NEW: Installation guide
└── skills/                       # Unchanged
```

## 實施計劃

### 第一階段：重構共享核心

1. 創造`lib/skills-core.js`
   - 從中提取 frontmatter 解析`.codex/superpowers-codex`
   - 提取技能發現邏輯
   - 提取路徑解析度（帶陰影）
   - 更新為僅使用`name`和`description`（不`when_to_use`)

2. 更新`.codex/superpowers-codex`使用共享核心
   - 導入自`../lib/skills-core.js`
   - 刪除重複的代碼
   - 保留 CLI 包裝邏輯

3. 測試 Codex 實作仍然有效
   - 驗證引導命令
   - 驗證使用技能命令
   - 驗證 find-skills 命令

### 第 2 階段：構建 OpenCode 插件

1. 創造`.opencode/plugin/superpowers.js`
   - 從以下位置導入共享核心`../../lib/skills-core.js`
   - 實現插件功能
   - 定義自訂工具（use_skill、find_skills）
   - 實現session.started鉤子

2. 創造`.opencode/INSTALL.md`
   - 安裝說明
   - 目錄設置
   - 配置指導

3. 測試 OpenCode 實施
   - 驗證會話啟動引導程序
   - 驗證 use_skill 工具是否有效
   - 驗證 find_skills 工具是否有效
   - 驗證技能目錄是否可訪問

### 第 3 階段：文件編製與潤飾

1. 更新 README 以支持 OpenCode
2. 將 OpenCode 安裝添加到主文檔中
3. 更新發行說明
4. 測試 Codex 和 OpenCode 是否正常工作

## 下一步

1. **創建獨立的工作區**（使用 git 工作樹）
   - 分支：`feature/opencode-support`

2. **遵循適用的 TDD**
   - 測試共享核心功能
   - 測試技能發現和解析
   - 兩個平臺的整合測試

3. **增量實施**
   - 第一階段：重構共享核心+更新Codex
   - 在繼續之前驗證 Codex 是否仍然有效
   - 第 2 階段：構建 OpenCode 插件
   - 第 3 階段：文件和完善

4. **測試策略**
   - 使用真正的 OpenCode 安裝進行手動測試
   - 驗證技能載入、目錄、腳本是否有效
   - 並行測試 Codex 和 OpenCode
   - 驗證工具映射是否正常運作

5. **公關與合併**
   - 創建公關並完整實施
   - 潔淨環境下測試
   - 合併到主目錄

## 好處

- **代碼重用**：技能發現/解析的單一事實來源
- **可維護性**：錯誤修復適用於兩個平臺
- **可擴充性**：輕鬆新增未來平臺（Cursor、Windsurf 等）
- **本機整合**：正確使用 OpenCode 的插件系統
- **一致性**：所有平臺上的技能體驗相同
