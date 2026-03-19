#!/usr/bin/env bash
# Minimal offline test: validates the existence and key markers of aile-writing-plans skill.
set -euo pipefail

skill_file="skills/aile-writing-plans/SKILL.md"
template_file="skills/aile-writing-plans/docs-templates/stage2-plan-template.md"

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

# Context contract markers
for pattern in "analysis\\.md" "优先上下文文件" "Jira Story 描述" "当前代码" "不负责\\*\\*创建 Jira Sub-task" "上下文降级规则" "降级模式" "计划阶段补齐" "档案系统回补任务" "档案系统回补建议"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing context marker [$pattern] in $skill_file" >&2
    exit 1
  fi
done

# Must not keep Jira sub-task creation contract
if rg -n "jira_create_issue|jira_batch_create_issues|Sub-task 创建契约|按任务列表逐条调用|人工补录" "$skill_file" >/dev/null; then
  echo "FAIL: stale Jira Sub-task contract still present in $skill_file" >&2
  exit 1
fi

# Status management markers
for pattern in "整体进度" "任务状态总览" "执行记录" "待开始"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing status marker [$pattern] in $skill_file" >&2
    exit 1
  fi
done

for pattern in "前置檢查" "任務看板" "檔案系統回補任務" "執行記錄"; do
  if ! rg -n "$pattern" "$template_file" >/dev/null; then
    echo "FAIL: missing status marker [$pattern] in $template_file" >&2
    exit 1
  fi
done

echo "PASS: aile-writing-plans skill markers present"
