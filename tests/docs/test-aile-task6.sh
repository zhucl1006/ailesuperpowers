#!/usr/bin/env bash
# Offline checks for task 6: aile-pencil-design and G2 checklist.
set -euo pipefail

required_files=(
  "skills/aile-pencil-design/SKILL.md"
  "docs/templates/g2-design-review-checklist.md"
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

skill_file="skills/aile-pencil-design/SKILL.md"
if ! rg -n "^name:\s*aile-pencil-design\s*$" "$skill_file" >/dev/null; then
  echo "FAIL: frontmatter name mismatch in $skill_file" >&2
  exit 1
fi

if ! rg -n "来源原 Skill" "$skill_file" >/dev/null; then
  echo "FAIL: missing source section in $skill_file" >&2
  exit 1
fi

echo "PASS: task6 artifacts present"
