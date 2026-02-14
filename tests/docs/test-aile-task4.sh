#!/usr/bin/env bash
# Offline checks for task 4: aile-code-review and aile-delivery-report.
set -euo pipefail

check_skill() {
  local skill_file="$1"
  local expected_name="$2"

  if [ ! -f "$skill_file" ]; then
    echo "MISSING: $skill_file" >&2
    return 1
  fi

  if ! rg -n "^name:\s*${expected_name}\s*$" "$skill_file" >/dev/null; then
    echo "FAIL: frontmatter name mismatch in $skill_file" >&2
    return 1
  fi

  if ! rg -n "来源原 Skill" "$skill_file" >/dev/null; then
    echo "FAIL: missing source section in $skill_file" >&2
    return 1
  fi

  return 0
}

check_skill "skills/aile-code-review/SKILL.md" "aile-code-review"
check_skill "skills/aile-delivery-report/SKILL.md" "aile-delivery-report"

echo "PASS: task4 skills present"
