#!/usr/bin/env bash
# Minimal offline test: validates the existence and key markers of aile-writing-plans skill.
set -euo pipefail

skill_file="skills/aile-writing-plans/SKILL.md"

if [ ! -f "$skill_file" ]; then
  echo "MISSING: $skill_file" >&2
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
if ! rg -n "docs/plans/\{Story-Key\}/analysis\.md" "$skill_file" >/dev/null; then
  echo "FAIL: missing output contract path in $skill_file" >&2
  exit 1
fi

echo "PASS: aile-writing-plans skill markers present"
