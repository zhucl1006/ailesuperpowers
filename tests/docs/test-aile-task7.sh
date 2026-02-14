#!/usr/bin/env bash
# Offline checks for task 7: pilot report and release notes rollout notes.
set -euo pipefail

pilot_file="docs/plans/PILOT-STORY-REPORT.md"
release_file="RELEASE-NOTES.md"
real_story_analysis="docs/plans/AL-1651/analysis.md"

for f in "$pilot_file" "$release_file" "$real_story_analysis"; do
  if [ ! -f "$f" ]; then
    echo "MISSING: $f" >&2
    exit 1
  fi
done

if rg -n "\\{待填写\\}|\\{是/否\\}|YYYY-MM-DD" "$pilot_file" >/dev/null; then
  echo "FAIL: pilot report still contains unresolved placeholders" >&2
  exit 1
fi

if ! rg -n "Story Key：AILE-002" "$pilot_file" >/dev/null; then
  echo "FAIL: pilot story key not recorded in pilot report" >&2
  exit 1
fi

if ! rg -n "AL-1651" "$pilot_file" >/dev/null; then
  echo "FAIL: real jira story key not recorded in pilot report" >&2
  exit 1
fi

if ! rg -n "jira_get_issue|jira_transition_issue" "$pilot_file" >/dev/null; then
  echo "FAIL: pilot report missing jira tool-chain evidence" >&2
  exit 1
fi

if ! rg -n "^## v4\\.2\\.1 \\(2026-02-13\\)" "$release_file" >/dev/null; then
  echo "FAIL: release notes missing v4.2.1 section" >&2
  exit 1
fi

if ! rg -n "aile-\\*" "$release_file" >/dev/null; then
  echo "FAIL: release notes missing aile-* migration note" >&2
  exit 1
fi

echo "PASS: task7 pilot and release notes artifacts present"
