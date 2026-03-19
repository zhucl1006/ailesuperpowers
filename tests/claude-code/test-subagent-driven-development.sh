#!/usr/bin/env bash
# 測試：aile-subagent-dev 技能
# 验证技能可被辨识，且契约符合最新规范
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

# Claude CLI 偶發會返回空輸出；重試可降低測試波動。
run_claude_with_retry() {
    local prompt="$1"
    local timeout="$2"
    local attempts="${3:-2}"
    local allowed_tools="${4:-Read,Grep,Glob}"
    local output=""

    for ((i = 1; i <= attempts; i++)); do
        output=$(run_claude "$prompt" "$timeout" "$allowed_tools" || true)
        if [ -n "$(echo "$output" | tr -d '[:space:]')" ]; then
            echo "$output"
            return 0
        fi
        sleep 1
    done

    echo "$output"
    return 0
}

echo "=== 測試：aile-subagent-dev 技能 ==="
echo ""

# 测试 1：验证技能可被载入，并识别为 Codex subagent 模式
echo "测试 1：技能载入..."

output=$(run_claude_with_retry "请说明 aile-subagent-dev 技能，并简述它的核心模式。回答中需要提到 Codex subagent，以及 analysis.md 和 plan.md（或选定计划文件）。" 120)

if assert_contains "$output" "aile-subagent-dev\|Codex\|subagent\|子代理" "技能已被辨识"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "analysis\.md\|分析文件\|计划文件\|plan\.md" "提到 analysis 与计划文件"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 2：验证与 aile-executing-plans 的边界
echo "测试 2：技能边界..."

output=$(run_claude_with_retry "aile-subagent-dev 和 aile-executing-plans 有什么区别？请直接说明前者为什么是 subagent 模式，后者为什么不是。" 120)

if assert_contains "$output" "aile-executing-plans" "提到对比技能"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "subagent\|子代理\|控制器\|主线程\|单主代理\|单主代理模式" "说明模式差异"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 3：验证子代理角色选择
echo "测试 3：角色选择..."

output=$(run_claude_with_retry "在 aile-subagent-dev 中，implementer、spec reviewer、code quality reviewer 通常分别用哪类 Codex subagent？" 120)

if assert_contains "$output" "worker" "实现者使用 worker"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "explorer" "规格审查使用 explorer"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "default\|explorer" "质量审查使用 default 或 explorer"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 4：验证会分析系统其他角色并做匹配
echo "测试 4：系统角色匹配..."

output=$(run_claude_with_retry "如果 Codex 系统里除了 worker、explorer、default 之外，还有其他可用角色，aile-subagent-dev 应该怎么选？是固定用内置角色，还是先分析能力后选择更匹配的角色？" 120)

if assert_contains "$output" "先分析\|能力匹配\|更匹配的角色\|可用角色\|系统角色\|自定义" "会分析系统角色并做能力匹配"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 5：验证控制器同时读取 analysis 与计划，并构造 Task Package
echo "测试 5：上下文装载与任务派发..."

output=$(run_claude_with_retry "根据 aile-subagent-dev，主线程在开始阶段要读取哪些文件？之后是让子代理自己读整份文件，还是由控制器构造 Task Package 再派发？" 120)

if assert_contains "$output" "analysis\.md" "提到 analysis.md"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "plan\.md\|计划文件\|plan-" "提到计划文件"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Task Package\|任务包\|由控制器构造\|主线程构造" "提到 Task Package"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "不是让子代理自己读\|不让子代理自己读\|由控制器构造\|避免每个子代理重复读完整文档\|绝不要这样做" "明确由控制器派发而非子代理通读"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 6：验证审查顺序
echo "测试 6：审查顺序..."

output=$(run_claude_with_retry "在 aile-subagent-dev 中，规格合规审查与代码质量审查哪个先做？请明确说明先后顺序。" 120)

if assert_contains "$output" "先.*规格.*后.*代码质量\|先.*合规.*后.*质量\|spec.*before.*quality\|规格合规.*代码质量" "先规格合规，再代码质量"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 7：验证审查循环
echo "测试 7：审查循环..."

output=$(run_claude_with_retry "在 aile-subagent-dev 中，如果规格审查或代码质量审查发现问题，会如何处理？是一轮结束，还是返工后复审直到通过？" 120)

if assert_contains "$output" "返工\|复审\|循环\|直到通过\|直到合规\|until.*pass\|until.*approved" "提到返工复审循环"; then
    : # pass
else
    exit 1
fi

echo ""

# 测试 8：验证相关技能链路
echo "测试 8：相关技能..."

output=$(run_claude_with_retry "aile-subagent-dev 前后通常和哪些技能衔接？至少说出它前面的计划技能和后面的交付技能。" 120)

if assert_contains "$output" "aile-writing-plans" "提到前置计划技能"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "aile-delivery-report" "提到后置交付技能"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== aile-subagent-dev 技能测试全部通过 ==="
