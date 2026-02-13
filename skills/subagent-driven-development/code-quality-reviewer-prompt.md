# 代碼質量審核員提示模板

分派代碼質量審核員子代理時使用此模板。

**目的：** 驗證實施是否建置良好（乾淨、經過測試、可維護）

**僅在規格合規性審核通過後纔出貨。 **

```
Task tool (superpowers:code-reviewer):
  Use template at requesting-code-review/code-reviewer.md

  WHAT_WAS_IMPLEMENTED: [from implementer's report]
  PLAN_OR_REQUIREMENTS: Task N from [plan-file]
  BASE_SHA: [commit before task]
  HEAD_SHA: [current commit]
  DESCRIPTION: [task summary]
```

**代碼審查員返回：** 優勢、問題（關鍵/重要/次要）、評估
