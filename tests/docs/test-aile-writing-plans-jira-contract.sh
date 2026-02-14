#!/usr/bin/env bash
# Offline contract checks for Jira sub-task creation in aile-writing-plans.
set -euo pipefail

required_files=(
  "skills/aile-writing-plans/SKILL.md"
  "docs/templates/stage2-analysis-template.md"
  "docs/guides/JIRA-MCP-INTEGRATION.md"
  "docs/modules/aile-skill-mapping.md"
  "commands/aile-write-plan.md"
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

skill_file="skills/aile-writing-plans/SKILL.md"
for pattern in \
  "jira_create_issue" \
  "Sub-task" \
  "parent" \
  "labels" \
  "assignee" \
  "人工补录"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $skill_file" >&2
    exit 1
  fi
done

template_file="docs/templates/stage2-analysis-template.md"
for pattern in "Sub-task Key" "负责人" "状态" "备注"; do
  if ! rg -n "$pattern" "$template_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $template_file" >&2
    exit 1
  fi
done

guide_file="docs/guides/JIRA-MCP-INTEGRATION.md"
for pattern in "aile-writing-plans" "jira_create_issue" "summary" "description" "labels" "assignee" "人工补录"; do
  if ! rg -n "$pattern" "$guide_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $guide_file" >&2
    exit 1
  fi
done

mapping_file="docs/modules/aile-skill-mapping.md"
if ! rg -n "Sub-task 自动创建" "$mapping_file" >/dev/null; then
  echo "FAIL: missing Sub-task auto-create wording in $mapping_file" >&2
  exit 1
fi

command_file="commands/aile-write-plan.md"
if ! rg -n "启用 Jira MCP" "$command_file" >/dev/null; then
  echo "FAIL: missing Jira MCP hint in $command_file" >&2
  exit 1
fi

echo "PASS: aile-writing-plans Jira contract is enforced"
