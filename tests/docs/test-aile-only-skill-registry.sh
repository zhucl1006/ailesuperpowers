#!/usr/bin/env bash
# Guard for aile-only skill registry.
set -euo pipefail

MODE="${1:---strict}"
SKILLS_DIR="skills"
LEGACY_SKILL_REGEX="brainstorming|dispatching-parallel-agents|executing-plans|finishing-a-development-branch|receiving-code-review|requesting-code-review|subagent-driven-development|systematic-debugging|test-driven-development|using-git-worktrees|using-superpowers|verification-before-completion|writing-plans|writing-skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "FAIL: missing $SKILLS_DIR directory" >&2
  exit 1
fi

non_aile_raw="$(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type d | sed "s#^$SKILLS_DIR/##" | sort | grep -v "^aile-" || true)"
legacy_runtime_refs="$(rg -n "superpowers:(${LEGACY_SKILL_REGEX})|skills/(${LEGACY_SKILL_REGEX})" skills/aile-* 2>/dev/null || true)"

print_list() {
  local raw="$1"
  if [ -z "$raw" ]; then
    echo "  (none)"
    return
  fi

  while IFS= read -r skill; do
    [ -z "$skill" ] && continue
    echo "  - $skill"
  done <<LIST
$raw
LIST
}

if [ "$MODE" = "--report-only" ]; then
  echo "NON_AILE_SKILLS:"
  print_list "$non_aile_raw"
  echo "LEGACY_RUNTIME_REFS:"
  if [ -z "$legacy_runtime_refs" ]; then
    echo "  (none)"
  else
    echo "$legacy_runtime_refs" | sed "s/^/  - /"
  fi
  exit 0
fi

if [ "$MODE" != "--strict" ]; then
  echo "Usage: $0 [--report-only|--strict]" >&2
  exit 2
fi

if [ -n "$non_aile_raw" ]; then
  echo "NON_AILE_FOUND:" >&2
  print_list "$non_aile_raw" >&2
  exit 1
fi

if [ -n "$legacy_runtime_refs" ]; then
  echo "LEGACY_RUNTIME_REFS_FOUND:" >&2
  echo "$legacy_runtime_refs" | sed "s/^/  - /" >&2
  exit 1
fi

echo "PASS: only aile-* skills found"
