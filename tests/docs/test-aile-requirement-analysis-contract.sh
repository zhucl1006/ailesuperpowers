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
  "只负责分析、澄清、结构化输出，并产出/更新" \
  "不修改业务代码、测试代码、规格文档、模块文档" \
  "本技能默认\\*\\*不创建 Jira Sub-task\\*\\*" \
  "缺失 / gap / 小范围补漏 / 缺陷修补" \
  "分析阶段\\*\\*禁止\\*\\*创建子任务" \
  "默认答案为\\*\\*不创建\\*\\*" \
  "不得调用任何 .*jira_create_issue.*jira_batch_create_issues" \
  "档案系统回补建议" \
  "只记录“档案系统回补建议”" \
  "本阶段不执行回补" \
  "ADF（Atlassian Document Format）" \
  "默认\\*\\*不执行\\*\\* Jira Comment 回填" \
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
  "档案系统回补建议" \
  "本阶段只记录建议，不执行档案修改" \
  "Jira Comment ADF（如需回填）"; do
  if ! rg -n "$pattern" "$analysis_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $analysis_template" >&2
    exit 1
  fi
done

for pattern in \
  "只做分析并产出 .*analysis\\.md.*不创建 Sub-task" \
  "缺失 / gap / 补漏类单据：只输出分析，禁止创建 Sub-task" \
  "不得修改业务代码、测试代码、规格文档、模块文档" \
  "Comment 格式：如用户明确要求准备 Jira Comment，必须先生成 ADF payload" \
  "默认不执行自动回填"; do
  if ! rg -n "$pattern" "$jira_guide" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $jira_guide" >&2
    exit 1
  fi
done

for pattern in \
  "ADF 结构要求" \
  "子任务建议与决策" \
  "档案系统回补建议" \
  "不能自动回填"; do
  if ! rg -n "$pattern" "$comment_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $comment_template" >&2
    exit 1
  fi
done

echo "PASS: aile-requirement-analysis contract present"
