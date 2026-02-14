#!/usr/bin/env bash
# Offline contract checks for aile-pencil-design MCP-first workflow.
set -euo pipefail

required_files=(
  "skills/aile-pencil-design/SKILL.md"
  "commands/aile-pencil-design.md"
  "docs/templates/g2-design-review-checklist.md"
  "docs/modules/aile-skill-mapping.md"
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
for pattern in \
  "Pencil MCP 可执行性预检" \
  "batch_design" \
  "<=25" \
  "snapshot_layout" \
  "get_screenshot" \
  "DoD" \
  "本 Story 无 UI 设计"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $skill_file" >&2
    exit 1
  fi
done

command_file="commands/aile-pencil-design.md"
if ! rg -n "依赖 Pencil MCP" "$command_file" >/dev/null; then
  echo "FAIL: missing MCP prerequisite hint in $command_file" >&2
  exit 1
fi

checklist_file="docs/templates/g2-design-review-checklist.md"
for pattern in "布局检查" "关键节点截图" "失败回路"; do
  if ! rg -n "$pattern" "$checklist_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $checklist_file" >&2
    exit 1
  fi
done

mapping_file="docs/modules/aile-skill-mapping.md"
if ! rg -n "执行规范" "$mapping_file" >/dev/null; then
  echo "FAIL: missing execution-spec wording in $mapping_file" >&2
  exit 1
fi

echo "PASS: aile-pencil-design MCP contract is enforced"
