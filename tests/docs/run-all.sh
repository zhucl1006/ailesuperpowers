#!/usr/bin/env bash
# Runs all offline documentation/skill contract checks.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

failed=0
for t in "$SCRIPT_DIR"/test-*.sh; do
  echo "== Running: $(basename "$t") =="
  if ! bash "$t"; then
    failed=1
  fi
  echo ""
done

if [ "$failed" -ne 0 ]; then
  echo "FAILED: one or more offline checks failed" >&2
  exit 1
fi

echo "PASSED: all offline checks"
