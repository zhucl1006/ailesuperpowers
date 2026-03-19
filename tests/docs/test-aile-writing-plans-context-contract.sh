#!/usr/bin/env bash
# Offline contract checks for aile-writing-plans context rules.
set -euo pipefail

required_files=(
  "skills/aile-writing-plans/SKILL.md"
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
  "主上下文文件：" \
  "docs/plans/\\{Story-Key\\}/analysis\\.md" \
  "本技能\\*\\*不负责\\*\\*创建 Jira Sub-task" \
  "若 .*analysis\\.md.* 缺失" \
  "读取 Jira Story 描述、AC、附件链接" \
  "读取 .*docs/plans/\\{Story-Key\\}/analysis\\.md" \
  "若 Story 描述与 .*analysis\\.md.* 冲突" \
  "不负责.*创建 Jira Sub-task"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $skill_file" >&2
    exit 1
  fi
done

if rg -n "jira_create_issue|jira_batch_create_issues|Sub-task 创建契约|按任务列表逐条调用|人工补录" "$skill_file" >/dev/null; then
  echo "FAIL: stale Jira Sub-task contract still present in $skill_file" >&2
  exit 1
fi

guide_file="docs/guides/JIRA-MCP-INTEGRATION.md"
for pattern in \
  "aile-writing-plans.*不负责创建 Sub-task" \
  "主上下文：.*analysis\\.md" \
  "不负责：" \
  "调用 .*jira_create_issue" \
  "自动更新 Jira 状态"; do
  if ! rg -n "$pattern" "$guide_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $guide_file" >&2
    exit 1
  fi
done

mapping_file="docs/modules/aile-skill-mapping.md"
if ! rg -n "读取 Story 描述 \+ .*analysis\\.md" "$mapping_file" >/dev/null; then
  echo "FAIL: missing updated context wording in $mapping_file" >&2
  exit 1
fi

command_file="commands/aile-write-plan.md"
for pattern in "读取 Jira Story 描述与 docs/plans/\\{Story-Key\\}/analysis\\.md" "产出 docs/plans/\\{Story-Key\\}/plan\\.md"; do
  if ! rg -n "$pattern" "$command_file" >/dev/null; then
    echo "FAIL: missing command wording [$pattern] in $command_file" >&2
    exit 1
  fi
done

echo "PASS: aile-writing-plans context contract is enforced"
