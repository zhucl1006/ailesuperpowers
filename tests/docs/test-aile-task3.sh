#!/usr/bin/env bash
# Offline checks for task 3: aile-subagent-dev.
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

  local required_patterns=(
    "analysis\\.md"
    "plan\\.md|plan-\\{序号\\}\\.md|plan-\\{n\\}\\.md|计划文件"
    "Codex"
    "subagent|子代理"
    "worker"
    "explorer"
    "aile-executing-plans"
    "Task Package"
    "系统角色|自定义 subagent|可用角色|更匹配的系统角色"
  )

  local pattern
  for pattern in "${required_patterns[@]}"; do
    if ! rg -n "$pattern" "$skill_file" >/dev/null; then
      echo "FAIL: missing required contract pattern '$pattern' in $skill_file" >&2
      return 1
    fi
  done

  return 0
}

check_skill "skills/aile-subagent-dev/SKILL.md" "aile-subagent-dev"

echo "PASS: task3 skill present"
