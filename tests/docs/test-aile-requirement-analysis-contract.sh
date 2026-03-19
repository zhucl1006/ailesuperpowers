#!/usr/bin/env bash
# Offline checks for aile-requirement-analysis contract boundaries.
set -euo pipefail

skill_file="skills/aile-requirement-analysis/SKILL.md"
analysis_template="docs/templates/stage2-analysis-template.md"
jira_guide="docs/guides/JIRA-MCP-INTEGRATION.md"
comment_template="docs/templates/jira-comment-templates.md"

for f in "$skill_file" "$analysis_template" "$jira_guide" "$comment_template"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
done

for pattern in \
  "本技能默认\\*\\*不创建 Jira Sub-task\\*\\*" \
  "缺失 / gap / 小范围补漏 / 缺陷修补" \
  "分析阶段\\*\\*禁止\\*\\*创建子任务" \
  "默认答案为\\*\\*不创建\\*\\*" \
  "不得调用任何 .*jira_create_issue.*jira_batch_create_issues" \
  "ADF（Atlassian Document Format）" \
  "若当前工具链仅支持 Markdown Comment：禁止自动回填" \
  "Jira Comment ADF（待回填）"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $skill_file" >&2
    exit 1
  fi
done

for pattern in \
  "只分析，不创建 Sub-task" \
  "是否建议后续创建子任务" \
  "用户是否已明确授权创建子任务" \
  "本阶段禁止调用 .*jira_create_issue" \
  "Jira Comment ADF（如需回填）"; do
  if ! rg -n "$pattern" "$analysis_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $analysis_template" >&2
    exit 1
  fi
done

for pattern in \
  "只做分析与 Comment 回填，不创建 Sub-task" \
  "缺失 / gap / 补漏类单据：只输出分析，禁止创建 Sub-task" \
  "Comment 格式：必须先生成 ADF payload" \
  "若运行环境仅支持 Markdown Comment：禁止自动回填"; do
  if ! rg -n "$pattern" "$jira_guide" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $jira_guide" >&2
    exit 1
  fi
done

for pattern in \
  "ADF 结构要求" \
  "子任务建议与决策" \
  "不能自动回填"; do
  if ! rg -n "$pattern" "$comment_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $comment_template" >&2
    exit 1
  fi
done

echo "PASS: aile-requirement-analysis contract present"
