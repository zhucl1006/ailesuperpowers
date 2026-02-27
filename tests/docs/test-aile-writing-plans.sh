#!/usr/bin/env bash
# Minimal offline test: validates the existence and key markers of aile-writing-plans skill.
set -euo pipefail

skill_file="skills/aile-writing-plans/SKILL.md"
template_file="docs/templates/stage2-analysis-template.md"

if [ ! -f "$skill_file" ]; then
  echo "MISSING: $skill_file" >&2
  exit 1
fi

if [ ! -f "$template_file" ]; then
  echo "MISSING: $template_file" >&2
  exit 1
fi

# Frontmatter markers
if ! rg -n "^name:\s*aile-writing-plans\s*$" "$skill_file" >/dev/null; then
  echo "FAIL: frontmatter name mismatch in $skill_file" >&2
  exit 1
fi

# Traceability markers
if ! rg -n "来源原 Skill" "$skill_file" >/dev/null; then
  echo "FAIL: missing \"来源原 Skill\" section in $skill_file" >&2
  exit 1
fi

# Output contract marker
if ! rg -n "docs/plans/\{Story-Key\}/plan\.md" "$skill_file" >/dev/null; then
  echo "FAIL: missing output contract path in $skill_file" >&2
  exit 1
fi

# Jira contract marker
if ! rg -n "jira_create_issue" "$skill_file" >/dev/null; then
  echo "FAIL: missing Jira Sub-task contract in $skill_file" >&2
  exit 1
fi

# Status management markers
for pattern in "整体进度" "任务状态总览" "执行记录" "待开始"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing status marker [$pattern] in $skill_file" >&2
    exit 1
  fi
done

for pattern in "执行状态管理" "整体进度" "任务状态总览" "执行记录"; do
  if ! rg -n "$pattern" "$template_file" >/dev/null; then
    echo "FAIL: missing status marker [$pattern] in $template_file" >&2
    exit 1
  fi
done

echo "PASS: aile-writing-plans skill markers present"
