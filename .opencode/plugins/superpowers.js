/**
 * OpenCode.ai 的 Superpowers 外掛
 *
 * 透過系統提示詞轉換注入 superpowers 啟動上下文。
 * 技能由 OpenCode 原生 skill 工具從符號連結目錄中發現。
 */

import path from 'path';
import fs from 'fs';
import os from 'os';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// 簡易 frontmatter 解析（避免 bootstrap 階段依賴 skills-core）
const extractAndStripFrontmatter = (content) => {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { frontmatter: {}, content };

  const frontmatterStr = match[1];
  const body = match[2];
  const frontmatter = {};

  for (const line of frontmatterStr.split('\n')) {
    const colonIdx = line.indexOf(':');
    if (colonIdx > 0) {
      const key = line.slice(0, colonIdx).trim();
      const value = line.slice(colonIdx + 1).trim().replace(/^["']|["']$/g, '');
      frontmatter[key] = value;
    }
  }

  return { frontmatter, content: body };
};

// 路徑標準化：去除空白、展開 ~、轉為絕對路徑
const normalizePath = (p, homeDir) => {
  if (!p || typeof p !== 'string') return null;
  let normalized = p.trim();
  if (!normalized) return null;
  if (normalized.startsWith('~/')) {
    normalized = path.join(homeDir, normalized.slice(2));
  } else if (normalized === '~') {
    normalized = homeDir;
  }
  return path.resolve(normalized);
};

export const SuperpowersPlugin = async ({ client, directory }) => {
  const homeDir = os.homedir();
  const superpowersSkillsDir = path.resolve(__dirname, '../../skills');
  const envConfigDir = normalizePath(process.env.OPENCODE_CONFIG_DIR, homeDir);
  const configDir = envConfigDir || path.join(homeDir, '.config/opencode');

  // 生成 bootstrap 內容的輔助函式
  const getBootstrapContent = () => {
    // 嘗試載入 using-superpowers 技能
    const skillPath = path.join(superpowersSkillsDir, 'using-superpowers', 'SKILL.md');
    if (!fs.existsSync(skillPath)) return null;

    const fullContent = fs.readFileSync(skillPath, 'utf8');
    const { content } = extractAndStripFrontmatter(fullContent);

    const toolMapping = `**OpenCode 工具映射：**
當技能文檔引用你目前沒有的工具時，請使用 OpenCode 對應工具：
- \`TodoWrite\` → \`update_plan\`
- \`Task\`（含子代理）→ 使用 OpenCode 子代理系統（@mention）
- \`Skill\` 工具 → OpenCode 原生 \`skill\` 工具
- \`Read\`、\`Write\`、\`Edit\`、\`Bash\` → 你的原生工具

**技能目錄：**
Superpowers 技能位於 \`${configDir}/skills/superpowers/\`
請使用 OpenCode 原生 \`skill\` 工具列出並載入技能。`;

    return `<EXTREMELY_IMPORTANT>
你已啟用 superpowers。

**重要：下方已包含 using-superpowers 的完整內容，而且已經載入。你目前正在遵循它。不要再次用 skill 工具重複載入 "using-superpowers"。**

${content}

${toolMapping}
</EXTREMELY_IMPORTANT>`;
  };

  return {
    // 使用 system prompt transform 注入 bootstrap（修復 #226 代理重置問題）
    'experimental.chat.system.transform': async (_input, output) => {
      const bootstrap = getBootstrapContent();
      if (bootstrap) {
        (output.system ||= []).push(bootstrap);
      }
    }
  };
};
