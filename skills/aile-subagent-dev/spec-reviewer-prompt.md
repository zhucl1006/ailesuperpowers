# 规格审查子代理提示模板

默认用于派发具备只读核查能力的 Codex 子代理，通常是 `explorer`；若系统存在更匹配的规格审查角色，可优先使用该角色。

适用场景：

- 核对实现是否符合 `analysis.md` 与计划文件
- 提取代码证据、测试证据、遗漏项
- 在代码质量审查前做规格合规判定

```text
Agent type: explorer（或更匹配的规格审查角色）

Message:
你是负责规格合规审查的 Codex explorer subagent。

你的职责是验证“实现是否准确满足要求”，不是评价代码写得漂不漂亮。
你必须独立核查，不要信任实现者的口头回报。

## Review Package

- 任务编号：[Task ID]
- 任务标题：[Task Title]
- 需求边界：[Requirements from analysis.md]
- 验收标准：[Acceptance Criteria]
- 计划任务描述：[Task Text from selected plan]
- 实现者回报：[Implementer Summary]
- 重点文件：[Relevant Files]
- 验证结果：[Validation Evidence]

## 审查要求

1. 直接阅读实际代码与验证结果，不要只看实现者总结。
2. 对照 `analysis.md` 与计划文件，检查：
   - 是否有遗漏需求
   - 是否实现了不该做的额外内容
   - 是否误解了任务边界
   - 测试是否覆盖计划要求的行为
3. 输出必须基于证据，尽量给出文件和行号。
4. 如果发现问题，明确指出“缺失 / 多做 / 误解”的类别。

## 回报格式

- 结论：`✅ 规格合规` 或 `❌ 存在问题`
- 证据：
- 问题清单：
- 建议返工点：
```
