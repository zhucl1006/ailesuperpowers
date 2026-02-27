#!/usr/bin/env bash
# Offline checks for task 5: Jira MCP docs and aile-requirement-analysis.
set -euo pipefail

required_files=(
  "skills/aile-requirement-analysis/SKILL.md"
  "docs/guides/JIRA-MCP-INTEGRATION.md"
  "docs/templates/jira-comment-templates.md"
)

missing=0
for f in "${required_files[@]}"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f" >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  exit 1
fi

skill_file="skills/aile-requirement-analysis/SKILL.md"
if ! rg -n "^name:\s*aile-requirement-analysis\s*$" "$skill_file" >/dev/null; then
  echo "FAIL: frontmatter name mismatch in $skill_file" >&2
  exit 1
fi

if ! rg -n "来源原 Skill" "$skill_file" >/dev/null; then
  echo "FAIL: missing source section in $skill_file" >&2
  exit 1
fi

echo "PASS: task5 artifacts present"
