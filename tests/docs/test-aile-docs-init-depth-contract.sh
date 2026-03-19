#!/usr/bin/env bash
# Offline contract checks for aile-docs-init mode B depth requirements.
set -euo pipefail

skill_file="skills/aile-docs-init/SKILL.md"
prd_template="skills/aile-docs-init/docs-templates/PRD-template.md"
sad_template="skills/aile-docs-init/docs-templates/SAD-template.md"
module_template="skills/aile-docs-init/docs-templates/module-template.md"
codebase_template="skills/aile-docs-init/docs-templates/CODEBASE-ANALYSIS-template.md"
readme_template="skills/aile-docs-init/docs-templates/README-template.md"

for f in \
  "$skill_file" \
  "$prd_template" \
  "$sad_template" \
  "$module_template" \
  "$codebase_template" \
  "$readme_template"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
done

for pattern in \
  "模式 B 深度回补默认规则" \
  "默认使用\\*\\*详细版\\*\\*" \
  "docs/specs/CODEBASE-ANALYSIS.md" \
  "代码证据画像" \
  "功能实现矩阵" \
  "代码仓结构视图" \
  "文件/目录详单" \
  "关键调用链 / 时序" \
  "测试缺口" \
  "详单优先于概括"; do
  if ! rg -n "$pattern" "$skill_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $skill_file" >&2
    exit 1
  fi
done

for pattern in \
  "信息来源与可信度" \
  "功能实现矩阵" \
  "关键用户旅程 / 业务流程" \
  "待确认事项"; do
  if ! rg -n "$pattern" "$prd_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $prd_template" >&2
    exit 1
  fi
done

for pattern in \
  "代码仓结构视图" \
  "运行时入口与启动链路" \
  "模块实现映射" \
  "配置与环境变量" \
  "技术债与演进建议"; do
  if ! rg -n "$pattern" "$sad_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $sad_template" >&2
    exit 1
  fi
done

for pattern in \
  "实现状态矩阵" \
  "代码结构详单" \
  "关键调用链 / 时序" \
  "配置项清单" \
  "测试缺口" \
  "改造建议"; do
  if ! rg -n "$pattern" "$module_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $module_template" >&2
    exit 1
  fi
done

for pattern in \
  "代码仓分析详单" \
  "目录树摘要" \
  "模块地图" \
  "外部契约盘点" \
  "环境变量矩阵" \
  "技术债与风险"; do
  if ! rg -n "$pattern" "$codebase_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $codebase_template" >&2
    exit 1
  fi
done

for pattern in \
  "CODEBASE-ANALYSIS.md" \
  "代码仓分析详单" \
  "追踪代码入口、模块文件和配置项"; do
  if ! rg -n "$pattern" "$readme_template" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $readme_template" >&2
    exit 1
  fi
done

echo "PASS: aile-docs-init mode B depth contract present"
