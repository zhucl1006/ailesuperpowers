# OpenCode 支援實施計劃

> **對於克勞德：** 所需的子技能：使用超能力：執行計劃來逐個任務地實施該計劃。

**目標：** 使用與現有 Codex 實作共享核心功能的原生 JavaScript 外掛程式來新增對 OpenCode.ai 的完整超級支援。

**架構：** 將常用技能發現/解析邏輯提取成`lib/skills-core.js`，重構 Codex 以使用它，然後使用其本機插件 API 以及自訂工具和會話掛鉤來建立 OpenCode 插件。

**技術堆棧：** Node.js、JavaScript、OpenCode 插件 API、Git 工作樹

---

## 第 1 階段：創建共享核心模塊

### 任務 1：提取 Frontmatter 解析

**文件：**
- 創造：`lib/skills-core.js`
- 參考：`.codex/superpowers-codex`（第 40-74 行）

**步驟1：使用extractFrontmatter函數建立lib/skills-core.js**

```javascript
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Extract YAML frontmatter from a skill file.
 * Current format:
 * ---
 * name: skill-name
 * description: Use when [condition] - [what it does]
 * ---
 *
 * @param {string} filePath - Path to SKILL.md file
 * @returns {{name: string, description: string}}
 */
function extractFrontmatter(filePath) {
    try {
        const content = fs.readFileSync(filePath, 'utf8');
        const lines = content.split('\n');

        let inFrontmatter = false;
        let name = '';
        let description = '';

        for (const line of lines) {
            if (line.trim() === '---') {
                if (inFrontmatter) break;
                inFrontmatter = true;
                continue;
            }

            if (inFrontmatter) {
                const match = line.match(/^(\w+):\s*(.*)$/);
                if (match) {
                    const [, key, value] = match;
                    switch (key) {
                        case 'name':
                            name = value.trim();
                            break;
                        case 'description':
                            description = value.trim();
                            break;
                    }
                }
            }
        }

        return { name, description };
    } catch (error) {
        return { name: '', description: '' };
    }
}

module.exports = {
    extractFrontmatter
};
```

**第 2 步：驗證文件是否已創建**

跑步：`ls -l lib/skills-core.js`
預期：文件存在

**第 3 步：承諾**

```bash
git add lib/skills-core.js
git commit -m "feat: create shared skills core module with frontmatter parser"
```

---

### 任務2：提取技能發現邏輯

**文件：**
- 調整：`lib/skills-core.js`
- 參考：`.codex/superpowers-codex`（第 97-136 行）

**步驟1：將findSkillsInDir函數添加到skills-core.js**

添加之前`module.exports`:

```javascript
/**
 * Find all SKILL.md files in a directory recursively.
 *
 * @param {string} dir - Directory to search
 * @param {string} sourceType - 'personal' or 'superpowers' for namespacing
 * @param {number} maxDepth - Maximum recursion depth (default: 3)
 * @returns {Array<{path: string, name: string, description: string, sourceType: string}>}
 */
function findSkillsInDir(dir, sourceType, maxDepth = 3) {
    const skills = [];

    if (!fs.existsSync(dir)) return skills;

    function recurse(currentDir, depth) {
        if (depth > maxDepth) return;

        const entries = fs.readdirSync(currentDir, { withFileTypes: true });

        for (const entry of entries) {
            const fullPath = path.join(currentDir, entry.name);

            if (entry.isDirectory()) {
                // Check for SKILL.md in this directory
                const skillFile = path.join(fullPath, 'SKILL.md');
                if (fs.existsSync(skillFile)) {
                    const { name, description } = extractFrontmatter(skillFile);
                    skills.push({
                        path: fullPath,
                        skillFile: skillFile,
                        name: name || entry.name,
                        description: description || '',
                        sourceType: sourceType
                    });
                }

                // Recurse into subdirectories
                recurse(fullPath, depth + 1);
            }
        }
    }

    recurse(dir, 0);
    return skills;
}
```

**步驟2：更新module.exports**

將導出行替換為：

```javascript
module.exports = {
    extractFrontmatter,
    findSkillsInDir
};
```

**步驟 3：驗證語法**

跑步：`node -c lib/skills-core.js`
預期：無輸出（成功）

**第 4 步：承諾**

```bash
git add lib/skills-core.js
git commit -m "feat: add skill discovery function to core module"
```

---

### 任務3：提取技能解析邏輯

**文件：**
- 調整：`lib/skills-core.js`
- 參考：`.codex/superpowers-codex`（第 212-280 行）

**第1步：新增resolveSkillPath函數**

添加之前`module.exports`:

```javascript
/**
 * Resolve a skill name to its file path, handling shadowing
 * (personal skills override superpowers skills).
 *
 * @param {string} skillName - Name like "superpowers:brainstorming" or "my-skill"
 * @param {string} superpowersDir - Path to superpowers skills directory
 * @param {string} personalDir - Path to personal skills directory
 * @returns {{skillFile: string, sourceType: string, skillPath: string} | null}
 */
function resolveSkillPath(skillName, superpowersDir, personalDir) {
    // Strip superpowers: prefix if present
    const forceSuperpowers = skillName.startsWith('superpowers:');
    const actualSkillName = forceSuperpowers ? skillName.replace(/^superpowers:/, '') : skillName;

    // Try personal skills first (unless explicitly superpowers:)
    if (!forceSuperpowers && personalDir) {
        const personalPath = path.join(personalDir, actualSkillName);
        const personalSkillFile = path.join(personalPath, 'SKILL.md');
        if (fs.existsSync(personalSkillFile)) {
            return {
                skillFile: personalSkillFile,
                sourceType: 'personal',
                skillPath: actualSkillName
            };
        }
    }

    // Try superpowers skills
    if (superpowersDir) {
        const superpowersPath = path.join(superpowersDir, actualSkillName);
        const superpowersSkillFile = path.join(superpowersPath, 'SKILL.md');
        if (fs.existsSync(superpowersSkillFile)) {
            return {
                skillFile: superpowersSkillFile,
                sourceType: 'superpowers',
                skillPath: actualSkillName
            };
        }
    }

    return null;
}
```

**步驟2：更新module.exports**

```javascript
module.exports = {
    extractFrontmatter,
    findSkillsInDir,
    resolveSkillPath
};
```

**步驟 3：驗證語法**

跑步：`node -c lib/skills-core.js`
預期：無輸出

**第 4 步：承諾**

```bash
git add lib/skills-core.js
git commit -m "feat: add skill path resolution with shadowing support"
```

---

### 任務4：提取更新檢查邏輯

**文件：**
- 調整：`lib/skills-core.js`
- 參考：`.codex/superpowers-codex`（第 16-38 行）

**第1步：添加checkForUpdates功能**

在requires之後添加在頂部：

```javascript
const { execSync } = require('child_process');
```

添加之前`module.exports`:

```javascript
/**
 * Check if a git repository has updates available.
 *
 * @param {string} repoDir - Path to git repository
 * @returns {boolean} - True if updates are available
 */
function checkForUpdates(repoDir) {
    try {
        // Quick check with 3 second timeout to avoid delays if network is down
        const output = execSync('git fetch origin && git status --porcelain=v1 --branch', {
            cwd: repoDir,
            timeout: 3000,
            encoding: 'utf8',
            stdio: 'pipe'
        });

        // Parse git status output to see if we're behind
        const statusLines = output.split('\n');
        for (const line of statusLines) {
            if (line.startsWith('## ') && line.includes('[behind ')) {
                return true; // We're behind remote
            }
        }
        return false; // Up to date
    } catch (error) {
        // Network down, git error, timeout, etc. - don't block bootstrap
        return false;
    }
}
```

**步驟2：更新module.exports**

```javascript
module.exports = {
    extractFrontmatter,
    findSkillsInDir,
    resolveSkillPath,
    checkForUpdates
};
```

**步驟 3：驗證語法**

跑步：`node -c lib/skills-core.js`
預期：無輸出

**第 4 步：承諾**

```bash
git add lib/skills-core.js
git commit -m "feat: add git update checking to core module"
```

---

## 第 2 階段：重構 Codex 以使用共享核心

### 任務 5：更新 Codex 以導入共享核心

**文件：**
- 調整：`.codex/superpowers-codex`（在頂部添加導入）

**第1步：添加導入語句**

在文件頂部的現有需求之後（第 6 行左右），添加：

```javascript
const skillsCore = require('../lib/skills-core');
```

**第 2 步：驗證語法**

跑步：`node -c .codex/superpowers-codex`
預期：無輸出

**第 3 步：承諾**

```bash
git add .codex/superpowers-codex
git commit -m "refactor: import shared skills core in codex"
```

---

### 任務 6：用 Core 版本替換 extractFrontmatter

**文件：**
- 調整：`.codex/superpowers-codex`（第 40-74 行）

**第1步：刪除本地extractFrontmatter函數**

刪除第 40-74 行（整個 extractFrontmatter 函數定義）。

**步驟 2：更新所有 extractFrontmatter 呼叫**

查找並替換來自以下位置的所有呼叫`extractFrontmatter(`到`skillsCore.extractFrontmatter(`

受影響的線路大約：90、310

**第 3 步：驗證腳本是否仍然有效**

跑步：`.codex/superpowers-codex find-skills | head -20`
預期：顯示技能列表

**第 4 步：承諾**

```bash
git add .codex/superpowers-codex
git commit -m "refactor: use shared extractFrontmatter in codex"
```

---

### 任務 7：將 findSkillsInDir 替換為核心版本

**文件：**
- 調整：`.codex/superpowers-codex`（約第 97-136 行）

**第1步：刪除本地findSkillsInDir函數**

刪除整個`findSkillsInDir`函數定義（大約第 97-136 行）。

**步驟 2：更新所有 findSkillsInDir 調用**

替換來自以下位置的呼叫`findSkillsInDir(`到`skillsCore.findSkillsInDir(`

**第 3 步：驗證腳本是否仍然有效**

跑步：`.codex/superpowers-codex find-skills | head -20`
預期：顯示技能列表

**第 4 步：承諾**

```bash
git add .codex/superpowers-codex
git commit -m "refactor: use shared findSkillsInDir in codex"
```

---

### 任務 8：將 checkForUpdates 替換為核心版本

**文件：**
- 調整：`.codex/superpowers-codex`（約第 16-38 行）

**第1步：刪除本地checkForUpdates功能**

刪除整個`checkForUpdates`函數定義。

**步驟 2：更新所有 checkForUpdates 調用**

替換來自以下位置的呼叫`checkForUpdates(`到`skillsCore.checkForUpdates(`

**第 3 步：驗證腳本是否仍然有效**

跑步：`.codex/superpowers-codex bootstrap | head -50`
預期：顯示引導內容

**第 4 步：承諾**

```bash
git add .codex/superpowers-codex
git commit -m "refactor: use shared checkForUpdates in codex"
```

---

## 第 3 階段：構建 OpenCode 插件

### 任務 9：建立 OpenCode 外掛程式目錄結構

**文件：**
- 創造：`.opencode/plugin/superpowers.js`

**第1步：建立目錄**

跑步：`mkdir -p .opencode/plugin`

**第2步：建立基本外掛程式檔案**

```javascript
#!/usr/bin/env node

/**
 * Superpowers plugin for OpenCode.ai
 *
 * Provides custom tools for loading and discovering skills,
 * with automatic bootstrap on session start.
 */

const skillsCore = require('../../lib/skills-core');
const path = require('path');
const fs = require('fs');
const os = require('os');

const homeDir = os.homedir();
const superpowersSkillsDir = path.join(homeDir, '.config/opencode/superpowers/skills');
const personalSkillsDir = path.join(homeDir, '.config/opencode/skills');

/**
 * OpenCode plugin entry point
 */
export const SuperpowersPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    // Custom tools and hooks will go here
  };
};
```

**第 3 步：驗證文件是否已建立**

跑步：`ls -l .opencode/plugin/superpowers.js`
預期：文件存在

**第 4 步：承諾**

```bash
git add .opencode/plugin/superpowers.js
git commit -m "feat: create opencode plugin scaffold"
```

---

### 任務 10：實作 use_skill 工具

**文件：**
- 調整：`.opencode/plugin/superpowers.js`

**第1步：添加use_skill工具實現**

將插件返回語句替換為：

```javascript
export const SuperpowersPlugin = async ({ project, client, $, directory, worktree }) => {
  // Import zod for schema validation
  const { z } = await import('zod');

  return {
    tools: [
      {
        name: 'use_skill',
        description: 'Load and read a specific skill to guide your work. Skills contain proven workflows, mandatory processes, and expert techniques.',
        schema: z.object({
          skill_name: z.string().describe('Name of the skill to load (e.g., "superpowers:brainstorming" or "my-custom-skill")')
        }),
        execute: async ({ skill_name }) => {
          // Resolve skill path (handles shadowing: personal > superpowers)
          const resolved = skillsCore.resolveSkillPath(
            skill_name,
            superpowersSkillsDir,
            personalSkillsDir
          );

          if (!resolved) {
            return `Error: Skill "${skill_name}" not found.\n\nRun find_skills to see available skills.`;
          }

          // Read skill content
          const fullContent = fs.readFileSync(resolved.skillFile, 'utf8');
          const { name, description } = skillsCore.extractFrontmatter(resolved.skillFile);

          // Extract content after frontmatter
          const lines = fullContent.split('\n');
          let inFrontmatter = false;
          let frontmatterEnded = false;
          const contentLines = [];

          for (const line of lines) {
            if (line.trim() === '---') {
              if (inFrontmatter) {
                frontmatterEnded = true;
                continue;
              }
              inFrontmatter = true;
              continue;
            }

            if (frontmatterEnded || !inFrontmatter) {
              contentLines.push(line);
            }
          }

          const content = contentLines.join('\n').trim();
          const skillDirectory = path.dirname(resolved.skillFile);

          // Format output similar to Claude Code's Skill tool
          return `# ${name || skill_name}
# ${description || ''}
# Supporting tools and docs are in ${skillDirectory}
# ============================================

${content}`;
        }
      }
    ]
  };
};
```

**第 2 步：驗證語法**

跑步：`node -c .opencode/plugin/superpowers.js`
預期：無輸出

**第 3 步：承諾**

```bash
git add .opencode/plugin/superpowers.js
git commit -m "feat: implement use_skill tool for opencode"
```

---

### 任務 11：實作 find_skills 工具

**文件：**
- 調整：`.opencode/plugin/superpowers.js`

**步驟 1：將 find_skills 工具加入到工具數組**

在 use_skill 工具定義之後、關閉工具數組之前添加：

```javascript
      {
        name: 'find_skills',
        description: 'List all available skills in the superpowers and personal skill libraries.',
        schema: z.object({}),
        execute: async () => {
          // Find skills in both directories
          const superpowersSkills = skillsCore.findSkillsInDir(
            superpowersSkillsDir,
            'superpowers',
            3
          );
          const personalSkills = skillsCore.findSkillsInDir(
            personalSkillsDir,
            'personal',
            3
          );

          // Combine and format skills list
          const allSkills = [...personalSkills, ...superpowersSkills];

          if (allSkills.length === 0) {
            return 'No skills found. Install superpowers skills to ~/.config/opencode/superpowers/skills/';
          }

          let output = 'Available skills:\n\n';

          for (const skill of allSkills) {
            const namespace = skill.sourceType === 'personal' ? '' : 'superpowers:';
            const skillName = skill.name || path.basename(skill.path);

            output += `${namespace}${skillName}\n`;
            if (skill.description) {
              output += `  ${skill.description}\n`;
            }
            output += `  Directory: ${skill.path}\n\n`;
          }

          return output;
        }
      }
```

**第 2 步：驗證語法**

跑步：`node -c .opencode/plugin/superpowers.js`
預期：無輸出

**第 3 步：承諾**

```bash
git add .opencode/plugin/superpowers.js
git commit -m "feat: implement find_skills tool for opencode"
```

---

### 任務 12：實施會話啟動掛鉤

**文件：**
- 調整：`.opencode/plugin/superpowers.js`

**步驟1：新增session.started鉤子**

在工具數組後面加上：

```javascript
    'session.started': async () => {
      // Read using-superpowers skill content
      const usingSuperpowersPath = skillsCore.resolveSkillPath(
        'using-superpowers',
        superpowersSkillsDir,
        personalSkillsDir
      );

      let usingSuperpowersContent = '';
      if (usingSuperpowersPath) {
        const fullContent = fs.readFileSync(usingSuperpowersPath.skillFile, 'utf8');
        // Strip frontmatter
        const lines = fullContent.split('\n');
        let inFrontmatter = false;
        let frontmatterEnded = false;
        const contentLines = [];

        for (const line of lines) {
          if (line.trim() === '---') {
            if (inFrontmatter) {
              frontmatterEnded = true;
              continue;
            }
            inFrontmatter = true;
            continue;
          }

          if (frontmatterEnded || !inFrontmatter) {
            contentLines.push(line);
          }
        }

        usingSuperpowersContent = contentLines.join('\n').trim();
      }

      // Tool mapping instructions
      const toolMapping = `
**Tool Mapping for OpenCode:**
When skills reference tools you don't have, substitute OpenCode equivalents:
- \`TodoWrite\` → \`update_plan\` (your planning/task tracking tool)
- \`Task\` tool with subagents → Use OpenCode's subagent system (@mention syntax or automatic dispatch)
- \`Skill\` tool → \`use_skill\` custom tool (already available)
- \`Read\`, \`Write\`, \`Edit\`, \`Bash\` → Use your native tools

**Skill directories contain supporting files:**
- Scripts you can run with bash tool
- Additional documentation you can read
- Utilities and helpers specific to that skill

**Skills naming:**
- Superpowers skills: \`superpowers:skill-name\` (from ~/.config/opencode/superpowers/skills/)
- Personal skills: \`skill-name\` (from ~/.config/opencode/skills/)
- Personal skills override superpowers skills when names match
`;

      // Check for updates (non-blocking)
      const hasUpdates = skillsCore.checkForUpdates(
        path.join(homeDir, '.config/opencode/superpowers')
      );

      const updateNotice = hasUpdates ?
        '\n\n⚠️ **Updates available!** Run `cd ~/.config/opencode/superpowers && git pull` to update superpowers.' :
        '';

      // Return context to inject into session
      return {
        context: `<EXTREMELY_IMPORTANT>
You have superpowers.

**Below is the full content of your 'superpowers:using-superpowers' skill - your introduction to using skills. For all other skills, use the 'use_skill' tool:**

${usingSuperpowersContent}

${toolMapping}${updateNotice}
</EXTREMELY_IMPORTANT>`
      };
    }
```

**第 2 步：驗證語法**

跑步：`node -c .opencode/plugin/superpowers.js`
預期：無輸出

**第 3 步：承諾**

```bash
git add .opencode/plugin/superpowers.js
git commit -m "feat: implement session.started hook for opencode"
```

---

## 第 4 階段：文檔記錄

### 任務 13：建立 OpenCode 安裝指南

**文件：**
- 創造：`.opencode/INSTALL.md`

**第 1 步：創建安裝指南**

```markdown
# Installing Superpowers for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Node.js installed
- Git installed

## Installation Steps

### 1. Install Superpowers Skills

```bash
# 將超能力技能複製到 OpenCode config 目錄
mkdir -p ~/.config/opencode/superpowers
git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers
```

### 2. Install the Plugin

The plugin is included in the superpowers repository you just cloned.

OpenCode will automatically discover it from:
- `~/.config/opencode/superpowers/.opencode/plugin/superpowers.js`

Or you can link it to the project-local plugin directory:

```bash
# 在您的 OpenCode 專案中
mkdir -p .opencode/插件
ln -s ~/.config/opencode/superpowers/.opencode/plugin/superpowers.js .opencode/plugin/superpowers.js
```

### 3. Restart OpenCode

Restart OpenCode to load the plugin. On the next session, you should see:

```
你有超能力。
```

## Usage

### Finding Skills

Use the `find_skills` tool to list all available skills:

```
使用 find_skills 工具
```

### Loading a Skill

Use the `use_skill` tool to load a specific skill:

```
使用 use_skill 工具和 Skill_name: "superpowers:brainstorming"
```

### Personal Skills

Create your own skills in `~/.config/opencode/skills/`:

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

Create `~/.config/opencode/skills/my-skill/SKILL.md`:

```markdown
---
名稱：我的技能
描述：當[條件] - [它的作用]時使用
---

# 我的技能

【你的技能內容在這裡】
```

Personal skills override superpowers skills with the same name.

## Updating

```bash
cd ~/.config/opencode/superpowers
git拉
```

## Troubleshooting

### Plugin not loading

1. Check plugin file exists: `ls ~/.config/opencode/superpowers/.opencode/plugin/superpowers.js`
2. Check OpenCode logs for errors
3. Verify Node.js is installed: `node --version`

### Skills not found

1. Verify skills directory exists: `ls ~/.config/opencode/superpowers/skills`
2. Use `find_skills` tool to see what's discovered
3. Check file structure: each skill should have a `SKILL.md` file

### Tool mapping issues

When a skill references a Claude Code tool you don't have:
- `TodoWrite` → use `update_plan`
- `Task` with subagents → use `@mention` syntax to invoke OpenCode subagents
- `Skill` → use `use_skill` tool
- File operations → use your native tools

## Getting Help

- Report issues: https://github.com/obra/superpowers/issues
- Documentation: https://github.com/obra/superpowers
```

**第 2 步：驗證創建的文件**

跑步：`ls -l .opencode/INSTALL.md`
預期：文件存在

**第 3 步：承諾**

```bash
git add .opencode/INSTALL.md
git commit -m "docs: add opencode installation guide"
```

---

### 任務 14：更新主自述文件

**文件：**
- 調整：`README.md`

**第 1 步：添加 OpenCode 部分**

找到有關支持平臺的部分（在文件中搜索“Codex”），並在其後面添加：

```markdown
### OpenCode

Superpowers works with [OpenCode.ai](https://opencode.ai) through a native JavaScript plugin.

**Installation:** See [.opencode/INSTALL.md](.opencode/INSTALL.md)

**Features:**
- Custom tools: `use_skill` and `find_skills`
- Automatic session bootstrap
- Personal skills with shadowing
- Supporting files and scripts access
```

**第 2 步：驗證格式**

跑步：`grep -A 10 "### OpenCode" README.md`
預期：顯示您新增的部分

**第 3 步：承諾**

```bash
git add README.md
git commit -m "docs: add opencode support to readme"
```

---

### 任務 15：更新發行說明

**文件：**
- 調整：`RELEASE-NOTES.md`

**第 1 步：添加 OpenCode 支持條目**

在文件頂部（標題之後）添加：

```markdown
## [Unreleased]

### Added

- **OpenCode Support**: Native JavaScript plugin for OpenCode.ai
  - Custom tools: `use_skill` and `find_skills`
  - Automatic session bootstrap with tool mapping instructions
  - Shared core module (`lib/skills-core.js`) for code reuse
  - Installation guide in `.opencode/INSTALL.md`

### Changed

- **Refactored Codex Implementation**: Now uses shared `lib/skills-core.js` module
  - Eliminates code duplication between Codex and OpenCode
  - Single source of truth for skill discovery and parsing

---

```

**第 2 步：驗證格式**

跑步：`head -30 RELEASE-NOTES.md`
預期：顯示您的新部分

**第 3 步：承諾**

```bash
git add RELEASE-NOTES.md
git commit -m "docs: add opencode support to release notes"
```

---

## 第五階段：最終驗證

### 任務 16：測試 Codex 仍然有效

**文件：**
- 測試：`.codex/superpowers-codex`

**第 1 步：測試 find-skills 指令**

跑步：`.codex/superpowers-codex find-skills | head -20`
預期：顯示技能列表以及名稱和描述

**第2步：測試使用技能命令**

跑步：`.codex/superpowers-codex use-skill superpowers:brainstorming | head -20`
預期：展現腦力激盪技能內容

**步驟 3：測試引導指令**

跑步：`.codex/superpowers-codex bootstrap | head -30`
預期：顯示帶有說明的引導程序內容

**第4步：如果所有測試都通過，則記錄成功**

無需提交 - 這僅是驗證。

---

### 任務 17：驗證文件結構

**文件：**
- 檢查：所有新文件都存在

**第 1 步：驗證創建的所有文件**

跑步：
```bash
ls -l lib/skills-core.js
ls -l .opencode/plugin/superpowers.js
ls -l .opencode/INSTALL.md
```

預期：所有文件都存在

**步驟 2：驗證目錄結構**

跑步：`tree -L 2 .opencode/`（或者`find .opencode -type f`如果樹不可用）
預期的：
```
.opencode/
├── INSTALL.md
└── plugin/
    └── superpowers.js
```

**第 3 步：如果結構正確，則繼續**

無需提交 - 這僅是驗證。

---

### 任務 18：最終提交和總結

**文件：**
- 查看：`git status`

**第 1 步：檢查 git 狀態**

跑步：`git status`
預期：工作樹乾淨，所有更改均已提交

**第 2 步：查看提交日誌**

跑步：`git log --oneline -20`
預期：顯示此實現的所有提交

**步驟 3：創建摘要文檔**

創建完成摘要，顯示：
- 總提交量
- 創建的文件：`lib/skills-core.js`, `.opencode/plugin/superpowers.js`, `.opencode/INSTALL.md`
- 修改的文件：`.codex/superpowers-codex`, `README.md`, `RELEASE-NOTES.md`
- 執行的測試：已驗證 Codex 命令
- 準備：使用實際的 OpenCode 安裝進行測試

**第4步：報告完成**

向用戶呈現摘要並提供給：
1. 推送到遠程
2. 建立拉取請求
3. 使用真實的 OpenCode 安裝進行測試（需要安裝 OpenCode）

---

## 測試指南（手動 - 需要 OpenCode）

這些步驟需要安裝 OpenCode，並且不是自動化實施的一部分：

1. **安裝技巧**：關注`.opencode/INSTALL.md`
2. **啟動 OpenCode 會話**：驗證引導程式是否出現
3. **測試 find_skills**：應列出所有可用技能
4. **測試 use_skill**：載入技能並驗證內容出現
5. **測試支持文件**：驗證技能目錄路徑是否可訪問
6. **測試個人技能**：創建個人技能並驗證其影子核心
7. **測試工具映射**：驗證 TodoWrite → update_plan 映射是否有效

## 成功標準

- [ ] `lib/skills-core.js`包含所有核心功能
- [ ] `.codex/superpowers-codex`重構為使用共享核心
- [ ] Codex 命令仍然有效（find-skills、use-skill、bootstrap）
- [ ] `.opencode/plugin/superpowers.js`使用工具和鉤子創建
- [ ] 安裝指南已創建
- [ ] 自述文件和發行說明已更新
- [ ] 已提交所有更改
- [ ] 工作樹清潔
