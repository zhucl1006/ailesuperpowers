# Jira Comment 模板（Aile）

> 目的：统一在 Jira 中的关键评论格式，确保 Gate 审查与交付信息可检索、可追溯。

## 1) G1 需求审查结论（开发负责人）

```
[G1] 需求审查结论：通过 / 打回
缺失项：
- ...
建议：
- ...
```

## 2) 阶段 2 计划 PR 链接（进入 DESIGN REVIEW 前）

```
[PLAN] 阶段2计划 PR：<PR链接>
@PM @QA Lead
说明：analysis.md + design.pencil（如有）已提交，请进行 G2 审查。
```

## 3) G2 设计审查结论（PM）

```
[G2] 设计审查结论：通过 / 打回
阻塞问题：
- ...
非阻塞建议：
- ...
```

## 4) 开发完成 PR 链接（进入 CODE REVIEW）

```
[DEV] 开发完成 PR：<PR链接>
验证：Lint/测试/构建（按 PR Description）
请 @Tech Lead 进行 Code Review。
```

## 5) QA 测试结论（QA Lead）

```
[QA] 测试结论：通过 / 不通过
Bug 列表：
- BUG-xxx ...
测试范围：
- ...
```

## 6) PM 验收结论（PM）

```
[PM] UI/体验验收：通过 / 不通过
问题与建议：
- ...
```
