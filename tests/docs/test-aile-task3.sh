#!/usr/bin/env bash
# Offline checks for task 3: aile-tdd and aile-subagent-dev.
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

check_skill "skills/aile-tdd/SKILL.md" "aile-tdd"
check_skill "skills/aile-subagent-dev/SKILL.md" "aile-subagent-dev"

echo "PASS: task3 skills present"
