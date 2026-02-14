#!/usr/bin/env bash
# Verifies required documentation templates and mapping docs exist.
set -euo pipefail

required_files=(
  "docs/templates/stage1-story-template.md"
  "docs/templates/stage2-analysis-template.md"
  "docs/templates/stage3-pr-description-template.md"
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
  echo "FAIL: required template files missing" >&2
  exit 1
fi

echo "PASS: required template files present"
