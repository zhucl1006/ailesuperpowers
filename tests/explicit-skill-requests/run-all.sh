#!/bin/bash
# Run all explicit skill request tests
# Usage: ./run-all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

echo "=== Running All Explicit Skill Request Tests ==="
echo ""

PASSED=0
FAILED=0
RESULTS=""

# Test: aile-subagent-dev, please
echo ">>> Test 1: aile-subagent-dev-please"
if "$SCRIPT_DIR/run-test.sh" "aile-subagent-dev" "$PROMPTS_DIR/aile-subagent-dev-please.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: aile-subagent-dev-please"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: aile-subagent-dev-please"
fi
echo ""

# Test: use aile-requirement-analysis
echo ">>> Test 2: use-aile-requirement-analysis"
if "$SCRIPT_DIR/run-test.sh" "aile-requirement-analysis" "$PROMPTS_DIR/use-aile-requirement-analysis.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: use-aile-requirement-analysis"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: use-aile-requirement-analysis"
fi
echo ""

# Test: please use aile-requirement-analysis
echo ">>> Test 3: please-use-aile-requirement-analysis"
if "$SCRIPT_DIR/run-test.sh" "aile-requirement-analysis" "$PROMPTS_DIR/please-use-aile-requirement-analysis.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: please-use-aile-requirement-analysis"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: please-use-aile-requirement-analysis"
fi
echo ""

# Test: mid-conversation execute plan
echo ">>> Test 4: mid-conversation-execute-plan"
if "$SCRIPT_DIR/run-test.sh" "aile-subagent-dev" "$PROMPTS_DIR/mid-conversation-execute-plan.txt"; then
    PASSED=$((PASSED + 1))
    RESULTS="$RESULTS\nPASS: mid-conversation-execute-plan"
else
    FAILED=$((FAILED + 1))
    RESULTS="$RESULTS\nFAIL: mid-conversation-execute-plan"
fi
echo ""

echo "=== Summary ==="
echo -e "$RESULTS"
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"
echo "Total: $((PASSED + FAILED))"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
