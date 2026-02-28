#!/usr/bin/env bash
# Offline contract checks for google-drive sync in aile skills.
set -euo pipefail

required_files=(
  "skills/aile-requirement-analysis/SKILL.md"
  "skills/aile-docs-init/SKILL.md"
  "skills/aile-requirement-analysis/docs-templates/google-drive-sync-integration.md"
  "skills/aile-docs-init/docs-templates/google-drive-sync-integration.md"
  "docs/guides/GOOGLE-DRIVE-SYNC-INTEGRATION.md"
  "docs/modules/aile-skill-mapping.md"
  "README.md"
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

req_skill="skills/aile-requirement-analysis/SKILL.md"
for pattern in \
  "规格回补评估" \
  "是否需要回补规格文件" \
  "回补文件清单" \
  "docs/\\*\\*/\\*\\.md" \
  "docs/plans/\\*\\*" \
  "docs/specs/\\*\\*/\\*\\.md" \
  "docs/modules/\\*\\*/\\*\\.md" \
  "docs/guides/\\*\\*/\\*\\.md" \
  "docs/database/\\*\\*/\\*\\.md" \
  "docs/api/\\*\\*/\\*\\.md" \
  "docs-templates/google-drive-sync-integration.md" \
  "分析判断产品归属" \
  "google-drive" \
  "NewAile文件" \
  "AiPool文件" \
  "无法确定" \
  "登录账号" \
  "当前工作目录" \
  "保留最近 5"; do
  if ! rg -n "$pattern" "$req_skill" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $req_skill" >&2
    exit 1
  fi
done

docs_init_skill="skills/aile-docs-init/SKILL.md"
for pattern in \
  "docs/\\*\\*/\\*\\.md" \
  "docs/specs/\\*\\*/\\*\\.md" \
  "docs/modules/\\*\\*/\\*\\.md" \
  "docs/guides/\\*\\*/\\*\\.md" \
  "docs/database/\\*\\*/\\*\\.md" \
  "docs/api/\\*\\*/\\*\\.md" \
  "docs/plans/\\*\\*" \
  "必须先分析文件是否属于“规格文件”" \
  "下其他目录：若判定为规格文件" \
  "relative-dir" \
  "docs-templates/google-drive-sync-integration.md" \
  "分析判断产品归属" \
  "必须全部通过" \
  "google-drive.*Skill.*执行" \
  "禁止自行编写脚本" \
  "禁止用全局名称搜索根目录" \
  "固定根目录 ID" \
  "校验文件父目录" \
  "\\[工程名字\\]/specs" \
  "\\[工程名字\\]/modules" \
  "google-drive" \
  "当前工作目录" \
  "保留最近 5" \
  "登录账号"; do
  if ! rg -n "$pattern" "$docs_init_skill" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $docs_init_skill" >&2
    exit 1
  fi
done

req_guide_file="skills/aile-requirement-analysis/docs-templates/google-drive-sync-integration.md"
for pattern in \
  "公用云端硬碟" \
  "NewAile文件" \
  "AiPool文件" \
  "02-功能規格" \
  "是否需要回补规格文件" \
  "回补文件清单" \
  "docs/\\*\\*/\\*\\.md" \
  "docs/plans/\\*\\*" \
  "docs/specs/\\*\\*/\\*\\.md" \
  "docs/modules/\\*\\*/\\*\\.md" \
  "docs/guides/\\*\\*/\\*\\.md" \
  "docs/database/\\*\\*/\\*\\.md" \
  "docs/api/\\*\\*/\\*\\.md" \
  "必须通过" \
  "google-drive.*Skill.*执行" \
  "分析判断" \
  "无法确定" \
  "根目录 ID" \
  "上传后必须校验文件父目录" \
  "当前工作目录" \
  "历史版本" \
  "保留最近 5" \
  "登录账号"; do
  if ! rg -n "$pattern" "$req_guide_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $req_guide_file" >&2
    exit 1
  fi
done

docs_init_guide_file="skills/aile-docs-init/docs-templates/google-drive-sync-integration.md"
for pattern in \
  "公用云端硬碟" \
  "NewAile文件" \
  "AiPool文件" \
  "02-功能規格" \
  "docs/\\*\\*/\\*\\.md" \
  "docs/specs/\\*\\*/\\*\\.md" \
  "docs/modules/\\*\\*/\\*\\.md" \
  "docs/guides/\\*\\*/\\*\\.md" \
  "docs/database/\\*\\*/\\*\\.md" \
  "docs/api/\\*\\*/\\*\\.md" \
  "docs/plans/\\*\\*" \
  "必须先分析" \
  "判定为“是”才允许同步" \
  "其他目录" \
  "relative-dir" \
  "分析判断" \
  "无法确定" \
  "共享盘入口（公用云端硬碟）" \
  "禁止上传到“我的云端硬碟”" \
  "必须通过" \
  "google-drive.*Skill.*执行" \
  "禁止用全局名称搜索定位根目录" \
  "1u2I7QtOQDzWnQAVgINZqQbLv0wOjvR_0" \
  "12nxdtruC9WtZlDRL58SCxb0BuWUSibqv" \
  "校验文件父目录" \
  "\\[工程名字\\]/specs" \
  "\\[工程名字\\]/modules" \
  "当前工作目录" \
  "历史版本" \
  "保留最近 5" \
  "登录账号"; do
  if ! rg -n "$pattern" "$docs_init_guide_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $docs_init_guide_file" >&2
    exit 1
  fi
done

mapping_file="docs/modules/aile-skill-mapping.md"
for pattern in "google-drive" "docs/modules" "docs/specs"; do
  if ! rg -n "$pattern" "$mapping_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $mapping_file" >&2
    exit 1
  fi
done

readme_file="README.md"
for pattern in "google-drive" "sanjay3290/ai-skills" "GOOGLE-DRIVE-SYNC-INTEGRATION"; do
  if ! rg -n "$pattern" "$readme_file" >/dev/null; then
    echo "FAIL: missing pattern [$pattern] in $readme_file" >&2
    exit 1
  fi
done

echo "PASS: google-drive sync contract present"
