#!/usr/bin/env bash
# Superpowers 外掛的 SessionStart 鉤子

set -euo pipefail

# 決定外掛根目錄
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# 檢查舊版技能目錄是否存在，並組合警示訊息
warning_message=""
legacy_skills_dir="${HOME}/.config/superpowers/skills"
if [ -d "$legacy_skills_dir" ]; then
    warning_message="\n\n<important-reminder>在你看到此訊息後的第一個回覆中，你必須告知使用者：⚠️ **警告：**Superpowers 現在使用 Claude Code 的技能系統。放在 ~/.config/superpowers/skills 的自訂技能將不會被讀取。請改放到 ~/.claude/skills。若要移除此提醒，請刪除 ~/.config/superpowers/skills</important-reminder>"
fi

# 讀取 using-superpowers 內容
using_superpowers_content=$(cat "${PLUGIN_ROOT}/skills/using-superpowers/SKILL.md" 2>&1 || echo "讀取 using-superpowers 技能時發生錯誤")

# 使用 bash 參數替換為 JSON 嵌入內容做跳脫。
# 每個 ${s//old/new} 都是單次 C 層級處理，
# 比逐字元迴圈快很多。
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

using_superpowers_escaped=$(escape_for_json "$using_superpowers_content")
warning_escaped=$(escape_for_json "$warning_message")

# 以 JSON 輸出上下文注入內容
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "<EXTREMELY_IMPORTANT>\n你已啟用 superpowers。\n\n**以下是 'superpowers:using-superpowers' 技能的完整內容（技能使用入門）。其他技能請透過 Skill 工具載入：**\n\n${using_superpowers_escaped}\n\n${warning_escaped}\n</EXTREMELY_IMPORTANT>"
  }
}
EOF

exit 0
