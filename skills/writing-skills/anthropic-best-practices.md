# 技能創作最佳實踐

> 瞭解如何寫出克勞德可以成功發現和使用的有效技能。

好的技能是簡潔的、結構良好的，並且經過實際使用的測試。本指南提供實用的創作決策，幫助您編寫 Claude 可以有效發現和使用的技能。

有關技能如何發揮作用的概念背景，請參閱[技能概述](/en/docs/agents-and-tools/agent-skills/overview)。

## 核心原則

### 簡潔是關鍵

[上下文窗口](https://platform.claude.com/docs/en/build-with-claude/context-windows) 是一項公共物品。您的技能與克勞德需要知道的其他所有內容共享上下文窗口，包括：

* 系統提示
* 對話歷史記錄
* 其他技能的元數據
* 您的實際要求

並非您技能中的每個標記都會立即產生費用。啟動時，僅預先載入所有技能的元資料（名稱和描述）。克勞德僅在技能相關時才讀取SKILL.md，僅在需要時才讀取其他文件。然而，SKILL.md 中的簡潔仍然很重要：一旦 Claude 加載它，每個令牌都會與對話歷史和其他上下文競爭。

**默認假設**：克勞德已經很聰明瞭

只添加克勞德還沒有的上下文。挑戰每一條信息：

*“克勞德真的需要這個解釋嗎？”
*“我可以假設克勞德知道這一點嗎？”
*“這一段是否證明其代幣成本合理？”

**好例子：簡潔**（大約 50 個標記）：

````markdown  theme={null}
## Extract PDF text

Use pdfplumber for text extraction:

```蟒蛇
導入 pdfplumber

pdfplumber.open("file.pdf") 為 pdf：
    文字 = pdf.pages[0].extract_text()```
````

**不好的例子：太冗長**（大約 150 個標記）：

```markdown  theme={null}
## Extract PDF text

PDF (Portable Document Format) files are a common file format that contains
text, images, and other content. To extract text from a PDF, you'll need to
use a library. There are many libraries available for PDF processing, but we
recommend pdfplumber because it's easy to use and handles most cases well.
First, you'll need to install it using pip. Then you can use the code below...
```

簡明版本假設 Claude 知道 PDF 是什麼以及圖書館如何工作。

### 設置適當的自由度

將具體程度與任務的脆弱性和可變性相匹配。

**高自由度**（基於文字的說明）：

使用時：

* 多種方法均有效
* 決定取決於具體情況
* 啟發式指導方法

例子：

```markdown  theme={null}
## Code review process

1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
```

**中等自由度**（帶有參數的偽代碼或腳本）：

使用時：

* 存在首選模式
* 一些變化是可以接受的
* 配置影響行為

例子：

````markdown  theme={null}
## Generate report

Use this template and customize as needed:

```蟒蛇
defgenerate_report（數據，格式=“markdown”，include_charts=True）：
    # 處理數據
    # 產生指定格式的輸出
    # 可選擇包含視覺化```
````

**低自由度**（特定腳本，很少或沒有參數）：

使用時：

* 操作脆弱且容易出錯
* 一致性至關重要
* 必須遵循特定的順序

例子：

````markdown  theme={null}
## Database migration

Run exactly this script:

```巴什
蟒蛇 scripts/migrate.py --verify --backup```

Do not modify the command or add additional flags.
````

**類比**：將克勞德想像成一個正在探索路徑的機器人：

* **兩邊都是懸崖的窄橋**：只有一條安全的前進道路。提供具體的護欄和準確的指示（低自由度）。示例：必須按精確順序運行的數據庫遷移。
* **沒有危險的開闊場地**：許多道路通向成功。給予大方向並信任克勞德找到最佳路線（高自由度）。示例：代碼審查，其中上下文決定最佳方法。

### 使用您計劃使用的所有模型進行測試

技能充當模型的補充，因此有效性取決於底層模型。使用您計劃使用的所有模型來測試您的技能。

**按模型測試注意事項**：

* **克勞德俳句**（快速、經濟）：該技能是否提供足夠的指導？
* **Claude Sonnet**（平衡）：技能是否清晰且有效率？
* **Claude Opus**（強而有力的推理）：該技能是否避免過度解釋？

對於 Opus 來說完美的方法可能對於 Haiku 來說需要更多細節。如果您計劃在多個模型中使用您的技能，請瞄準適用於所有模型的說明。

## 技能結構

<注意>
  **YAML Frontmatter**：SKILL.md frontmatter 支持兩個字段：

* `name` - 人類可讀的技能名稱（最多 64 個字元）
  * `description` - 一行描述該技能的作用以及何時使用該技能（最多 1024 個字元）

有關完整的技能結構詳細信息，請參閱[技能概述](/en/docs/agents-and-tools/agent-skills/overview#skill-struct)。
</注>

### 命名約定

使用一致的命名模式使技能更易於參考和討論。我們建議使用**動名詞形式**（動詞 + -ing）作為技能名稱，因為這清楚地描述了技能提供的活動或功能。

**良好的命名範例（動名詞形式）**：

*“處理 PDF”
*“分析電子表格”
*“管理數據庫”
*“測試代碼”
*“編寫文檔”

**可接受的替代方案**：

* 名詞短語：“PDF 處理”、“電子表格分析”
* 面向行動：“處理 PDF”、“分析電子表格”

**避免**：

* 模糊名稱：“Helper”、“Utils”、“Tools”
* 過於通用：“文檔”、“數據”、“文件”
* 你的技能集合中的模式不一致

一致的命名可以更輕鬆地：

* 文檔和對話中的參考技巧
* 一目瞭然瞭解技能的作用
* 整理和搜索多種技能
* 維護專業、有凝聚力的技能庫

### 撰寫有效的描述

`description` 字段支持技能發現，並且應包括技能的用途和使用時間。

<警告>
  **總是以第三人稱寫作**。描述被注入到系統提示中，不一致的觀點會導致發現問題。

* **好：**“處理 Excel 文件並生成報告”
  * **避免：** “我可以幫你處理Excel文件”
  * **避免：** “您可以使用它來處理 Excel 文件”
</警告>

**具體並包括關鍵術語**。包括該技能的用途以及何時使用該技能的特定觸發器/上下文。

每項技能都有一個描述欄位。描述對於技能選擇至關重要：Claude 使用它從潛在的 100 多個可用技能中選擇正確的技能。您的描述必須提供足夠的詳細信息，以便克勞德知道何時選擇此技能，而SKILL.md的其餘部分提供了實現細節。

有效例子：

**PDF處理技巧：**

```yaml  theme={null}
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

**Excel分析技巧：**

```yaml  theme={null}
description: Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files.
```

**Git 提交助手技能：**

```yaml  theme={null}
description: Generate descriptive commit messages by analyzing git diffs. Use when the user asks for help writing commit messages or reviewing staged changes.
```

避免諸如此類的模糊描述：

```yaml  theme={null}
description: Helps with documents
```

```yaml  theme={null}
description: Processes data
```

```yaml  theme={null}
description: Does stuff with files
```

### 漸進式披露模式

SKILL.md 充當概述，根據需要向 Claude 指出詳細材料，例如入門指南中的目錄。有關漸進式披露如何發揮作用的說明，請參閱概述中的[技能如何發揮作用](/en/docs/agents-and-tools/agent-skills/overview#how-skills-work)。

**實用指導：**

* 將 SKILL.md 正文控制在 500 行以下，以獲得最佳性能
* 當接近此限制時將內容拆分為單獨的文件
* 使用以下模式有效地組織指令、代碼和資源

#### 視覺概述：從簡單到複雜

基本技能從包含元資料和說明的 SKILL.md 檔案開始：

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=87782ff239b297d9a9e8e1b72ed72db9" alt="顯示 YAML frontmatter 和 markdown 正文的簡單 SKILL.md 文件" data-og-width="2048" width="2048" data-og-height="1153" height="1153" data-path=" data-og-height="1153」 srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=c61cc33b6f5855809907f7fda94cd80e 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=90d2c0c1c76b36e8d485f49e0810dbfd 560w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=ad17d231ac7b0bea7e5b4d58fb4aeabb 840w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=f5d0a7a3c668435bb0aee9a3a8f8c329 1100w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0e927c1af9de5799cfe557d12249f6e6 1650w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-simple-file.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=46bbb1a51dd4c8202a470ac8c80a893d 2500w"/>

隨著您的技能增長，您可以捆綁克勞德僅在需要時加載的其他內容：

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=a5e0aa41e3d53985a7e3e43668a33ea3" alt="捆綁其他參考文件，例如 reference.md 和 forms.md。 " data-og-width="2048" width="2048" data-og-height="1327" height="1327" data-path="images/agent-skills-bundling-content.png" data-optimize="true" data-opv="3" srcset="@@@TK4@ 2800="true" data-opv="3" srcset="@@@TK4@ 280w. 840w、https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=56f3be36c77e4fe4b523df209a6824c6 1100w、https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=d22b5161b2075656417d56f41a74f3dd 1650w、https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-bundling-content.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=3dd4bdd6850ffcc96c6c45fcb0acd6eb 2500w"/>

完整的 Skill 目錄結構可能如下所示：

```
pdf/
├── SKILL.md              # Main instructions (loaded when triggered)
├── FORMS.md              # Form-filling guide (loaded as needed)
├── reference.md          # API reference (loaded as needed)
├── examples.md           # Usage examples (loaded as needed)
└── scripts/
    ├── analyze_form.py   # Utility script (executed, not loaded)
    ├── fill_form.py      # Form filling script
    └── validate.py       # Validation script
```

#### 模式 1：帶有參考資料的高級指南

````markdown  theme={null}
---
name: PDF Processing
description: Extracts text and tables from PDF files, fills forms, and merges documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick start

Extract text with pdfplumber:
```蟒蛇
導入 pdfplumber
pdfplumber.open("file.pdf") 為 pdf：
    文本 = pdf.pages[0].extract_text()```

## Advanced features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
**Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
````

Claude 僅在需要時加載FORMS.md、REFERENCE.md 或EXAMPLES.md。

#### 模式 2：特定領域的組織

對於具有多個領域的技能，請按領域組織內容，以避免加載不相關的上下文。當用戶詢問銷售指標時，Claude 只需讀取與銷售相關的模式，而不是財務或營銷數據。這使得令牌使用量保持在較低水平並集中於上下文。

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

````markdown SKILL.md theme={null}
# BigQuery Data Analysis

## Available datasets

**Finance**: Revenue, ARR, billing → See [reference/finance.md](reference/finance.md)
**Sales**: Opportunities, pipeline, accounts → See [reference/sales.md](reference/sales.md)
**Product**: API usage, features, adoption → See [reference/product.md](reference/product.md)
**Marketing**: Campaigns, attribution, email → See [reference/marketing.md](reference/marketing.md)

## Quick search

Find specific metrics using grep:

```巴什
grep -i“收入”reference/finance.md
grep -i“管道”reference/sales.md
grep -i "api 用法" reference/product.md```
````

#### 模式 3：條件細節

顯示基本內容，進階內容連結：

```markdown  theme={null}
# DOCX Processing

## Creating documents

Use docx-js for new documents. See [DOCX-JS.md](DOCX-JS.md).

## Editing documents

For simple edits, modify the XML directly.

**For tracked changes**: See [REDLINING.md](REDLINING.md)
**For OOXML details**: See [OOXML.md](OOXML.md)
```

只有當使用者需要這些功能時，Claude 才會讀取REDLINING.md 或OOXML.md。

### 避免深層嵌套引用

當從其他引用的文件引用文件時，克勞德可能會部分讀取文件。當遇到嵌套引用時，Claude 可能會使用`head -100` 等指令來預覽內容，而不是讀取整個文件，導致資訊不完整。

**將引用保留在SKILL.md深一層**。所有參考文件應直接從SKILL.md鏈接，以確保克勞德在需要時讀取完整的文件。

**壞例子：太深了**：

```markdown  theme={null}
# SKILL.md
See [advanced.md](advanced.md)...

# advanced.md
See [details.md](details.md)...

# details.md
Here's the actual information...
```

**好例子：一層深**：

```markdown  theme={null}
# SKILL.md

**Basic usage**: [instructions in SKILL.md]
**Advanced features**: See [advanced.md](advanced.md)
**API reference**: See [reference.md](reference.md)
**Examples**: See [examples.md](examples.md)
```

### 使用目錄構建較長的參考文件

對於超過 100 行的參考文件，請在頂部包含目錄。這確保了克勞德即使在部分讀取預覽時也能看到完整的可用信息。

**例子**：

```markdown  theme={null}
# API Reference

## Contents
- Authentication and setup
- Core methods (create, read, update, delete)
- Advanced features (batch operations, webhooks)
- Error handling patterns
- Code examples

## Authentication and setup
...

## Core methods
...
```

然後，克勞德可以讀取完整的文件或根據需要跳轉到特定部分。

有關此基於文件系統的架構如何實現漸進式公開的詳細信息，請參閱下面“高級”部分中的[運行時環境](#runtime-environment)部分。

## 工作流程與回饋循環

### 使用工作流程來完成複雜的任務

將複雜的操作分解為清晰、連續的步驟。對於特別複雜的工作流程，請提供一個清單，克勞德可以將其複製到其回應中並在進展過程中進行核對。

**示例 1：研究綜合工作流程**（適用於無代碼的技能）：

````markdown  theme={null}
## Research synthesis workflow

Copy this checklist and track your progress:

```
Research Progress:
- [ ] Step 1: Read all source documents
- [ ] Step 2: Identify key themes
- [ ] Step 3: Cross-reference claims
- [ ] Step 4: Create structured summary
- [ ] Step 5: Verify citations
```

**Step 1: Read all source documents**

Review each document in the `sources/` directory. Note the main arguments and supporting evidence.

**Step 2: Identify key themes**

Look for patterns across sources. What themes appear repeatedly? Where do sources agree or disagree?

**Step 3: Cross-reference claims**

For each major claim, verify it appears in the source material. Note which source supports each point.

**Step 4: Create structured summary**

Organize findings by theme. Include:
- Main claim
- Supporting evidence from sources
- Conflicting viewpoints (if any)

**Step 5: Verify citations**

Check that every claim references the correct source document. If citations are incomplete, return to Step 3.
````

此範例展示了工作流程如何應用於不需要程式碼的分析任務。檢查表模式適用於任何複雜的多步驟流程。

**範例 2：PDF 表單填寫工作流程**（針對程式碼技能）：

````markdown  theme={null}
## PDF form filling workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```

**Step 1: Analyze the form**

Run: `python scripts/analyze_form.py input.pdf`

This extracts form fields and their locations, saving to `fields.json`.

**Step 2: Create field mapping**

Edit `fields.json` to add values for each field.

**Step 3: Validate mapping**

Run: `python scripts/validate_fields.py fields.json`

Fix any validation errors before continuing.

**Step 4: Fill the form**

Run: `python scripts/fill_form.py input.pdf fields.json output.pdf`

**Step 5: Verify output**

Run: `python scripts/verify_output.py output.pdf`

If verification fails, return to Step 2.
````

清晰的步驟可防止克勞德跳過關鍵驗證。此清單可協助 Claude 和您追蹤多步驟工作流程的進度。

### 實作回饋循環

**常見模式**：運行驗證器→修復錯誤→重複

這種模式極大地提高了輸出質量。

**範例 1：風格指南合規性**（對於沒有程式碼的技能）：

```markdown  theme={null}
## Content review process

1. Draft your content following the guidelines in STYLE_GUIDE.md
2. Review against the checklist:
   - Check terminology consistency
   - Verify examples follow the standard format
   - Confirm all required sections are present
3. If issues found:
   - Note each issue with specific section reference
   - Revise the content
   - Review the checklist again
4. Only proceed when all requirements are met
5. Finalize and save the document
```

這顯示了使用參考文檔而不是腳本的驗證循環模式。 “驗證器”是STYLE\_GUIDE.md，克勞德通過讀取和比較來進行檢查。

**範例 2：文件編輯流程**（針對程式碼技能）：

```markdown  theme={null}
## Document editing process

1. Make your edits to `word/document.xml`
2. **Validate immediately**: `python ooxml/scripts/validate.py unpacked_dir/`
3. If validation fails:
   - Review the error message carefully
   - Fix the issues in the XML
   - Run validation again
4. **Only proceed when validation passes**
5. Rebuild: `python ooxml/scripts/pack.py unpacked_dir/ output.docx`
6. Test the output document
```

驗證循環儘早發現錯誤。

## 內容指南

### 避免時間敏感的信息

不要包含會過時的信息：

**壞例子：時間敏感**（會出錯）：

```markdown  theme={null}
If you're doing this before August 2025, use the old API.
After August 2025, use the new API.
```

**好例子**（使用“舊模式”部分）：

```markdown  theme={null}
## Current method

Use the v2 API endpoint: `api.example.com/v2/messages`

## Old patterns

<details>
<summary>Legacy v1 API (deprecated 2025-08)</summary>

The v1 API used: `api.example.com/v1/messages`

This endpoint is no longer supported.
</details>
```

舊模式部分提供了歷史背景，但又不會擾亂主要內容。

### 使用一致的術語

選擇一個術語並在整個技能中使用它：

**好 - 一致**：

* 始終為“API端點”
* 總是“田地”
* 始終“提取”

**不好 - 不一致**：

* 混合“API端點”、“URL”、“API路由”、“路徑”
* 混合“欄位”、“框”、“元素”、“控制項”
* 混合“提取”、“拉取”、“獲取”、“檢索”

一致性有助於克勞德理解並遵循指示。

## 常見模式

### 模板模式

提供輸出格式的範本。將嚴格程度與您的需求相匹配。

**對於嚴格要求**（例如 API 回應或資料格式）：

````markdown  theme={null}
## Report structure

ALWAYS use this exact template structure:

```降價
# [分析標題]

## 執行摘要
[主要發現的一段概述]

## 主要發現
- 找到 1 並提供支持數據
- 發現 2 並提供支持數據
- 發現 3 並提供支持數據

## 建議
1. 具體可行的建議
2. 具體可行的建議```
````

**為了靈活指導**（當適應有用時）：

````markdown  theme={null}
## Report structure

Here is a sensible default format, but use your best judgment based on the analysis:

```降價
# [分析標題]

## 執行摘要
[概述]

## 主要發現
[根據您的發現調整部分]

## 建議
【依具體情況量身訂做】```

Adjust sections as needed for the specific analysis type.
````

### 範例模式

對於輸出質量取決於查看示例的技能，請像常規提示一樣提供輸入/輸出對：

````markdown  theme={null}
## Commit message format

Generate commit messages following these examples:

**Example 1:**
Input: Added user authentication with JWT tokens
Output:
```
feat(auth): implement JWT-based authentication

添加登錄端點和令牌驗證中間件```

**Example 2:**
Input: Fixed bug where dates displayed incorrectly in reports
Output:
```
fix(reports): correct date formatting in timezone conversion

在報告生成過程中一致使用 UTC 時間戳```

**Example 3:**
Input: Updated dependencies and refactored error handling
Output:
```
chore: update dependencies and refactor error handling

- 將lodash升級到4.17.21
- 跨端點標準化錯誤響應格式```

Follow this style: type(scope): brief description, then detailed explanation.
````

與單獨的描述相比，範例可以幫助克勞德更清楚地理解所需的風格和詳細程度。

### 條件工作流程模式

引導克勞德完成決策點：

```markdown  theme={null}
## Document modification workflow

1. Determine the modification type:

   **Creating new content?** → Follow "Creation workflow" below
   **Editing existing content?** → Follow "Editing workflow" below

2. Creation workflow:
   - Use docx-js library
   - Build document from scratch
   - Export to .docx format

3. Editing workflow:
   - Unpack existing document
   - Modify XML directly
   - Validate after each change
   - Repack when complete
```

<提示>
  如果工作流程變得龐大或複雜且包含許多步驟，請考慮將它們放入單獨的文件中，並告訴 Claude 根據手頭上的任務讀取適當的文件。
</提示>

## 評估和迭代

### 首先建立評估

**在編寫大量文件之前建立評估。 **這可確保您的技能解決實際問題，而不是記錄想像的問題。

**評估驅動的開發：**

1. **找出差距**：讓克勞德執行沒有技能的代表性任務。記錄特定的失敗或缺失的上下文
2. **創建評估**：構建三個場景來測試這些差距
3. **建立基線**：在沒有技能的情況下衡量克勞德的表現
4. **編寫最少的說明**：創建足夠的內容來彌補差距並通過評估
5. **迭代**：執行評估、與基線進行比較並完善

這種方法可確保您解決實際問題，而不是預測可能永遠不會實現的需求。

**評估結構**：

```json  theme={null}
{
  "skills": ["pdf-processing"],
  "query": "Extract all text from this PDF file and save it to output.txt",
  "files": ["test-files/document.pdf"],
  "expected_behavior": [
    "Successfully reads the PDF file using an appropriate PDF processing library or command-line tool",
    "Extracts text content from all pages in the document without missing any pages",
    "Saves the extracted text to a file named output.txt in a clear, readable format"
  ]
}
```

<注意>
  此示例演示了使用簡單測試規則的數據驅動評估。我們目前不提供運行這些評估的內置方法。用戶可以創建自己的評價體系。評估是衡量技能有效性的事實來源。
</注>

### 與 Claude 一起迭代開發技能

最有效的技能開發過程涉及克勞德本身。與克勞德的一個實例（“克勞德 A”）合作創建一項將由其他實例（“克勞德 B”）使用的技能。 Claude A 幫助您設計和完善指令，而 Claude B 在實際任務中測試它們。這是有效的，因為 Claude 模型瞭解如何編寫有效的代理指令以及代理需要什麼信息。

**建立新技能：**

1. **無需技能即可完成任務**：使用正常提示與 Claude A 一起解決問題。在工作時，您自然會提供背景信息、解釋偏好並分享程序知識。注意您反覆提供的信息。

2. **確定可重用模式**：完成任務後，確定您提供的上下文對未來類似的任務有用。

**示例**：如果您進行了 BigQuery 分析，您可能已經提供了表名稱、字段定義、過濾規則（例如“始終排除測試帳戶”）和常見查詢模式。

3. **要求 Claude A 創建一項技能**：“創建一項技能來捕獲我們剛剛使用的 BigQuery 分析模式。包括表架構、命名約定以及有關過濾測試帳戶的規則。”

<提示>
     Claude 模型本身就理解技能格式和結構。你不需要特殊的系統提示或“寫作技巧”技能來讓克勞德幫助創建技能。只需要求 Claude 創建一項技能，它就會生成結構正確的 SKILL.md 內容以及適當的 frontmatter 和 body 內容。
   </提示>

4. **審查簡潔性**：檢查Claude A沒有添加不必要的解釋。問：“刪除關於勝率意味著什麼的解釋——克勞德已經知道了。”

5. **改進資訊架構**：要求Claude A更有效地組織內容。例如：“對其進行組織，以便表架構位於單獨的參考文件中。稍後我們可能會添加更多表。”

6. **對類似任務進行測試**：在相關用例上使用 Claude B 的技能（已加載技能的新實例）。觀察 Claude B 是否找到正確的信息、正確應用規則並成功處理任務。

7. **基於觀察進行迭代**：如果 Claude B 遇到困難或錯過了某些內容，請返回給 Claude A 並提供具體信息：“當 Claude 使用此技能時，它忘記按 Q4 的日期進行過濾。我們是否應該添加有關日期過濾模式的部分？”

**迭代現有技能：**

當提高技能時，同樣的層次模式繼續存在。您可以交替使用：

* **與Claude A**（幫助完善技能的專家）一起工作
* **與 Claude B 一起測試**（使用技能執行實際工作的代理）
* **觀察克勞德 B 的行為** 並將見解帶回給克勞德 A

1. **在真實工作流程中使用技能**：給 Claude B（已加載技能）實際任務，而不是測試場景

2. **觀察 Claude B 的行為**：注意它在哪裡掙扎、成功或做出意想不到的選擇

**示例觀察**：“當我向 Claude B 索要區域銷售報告時，它編寫了查詢，但忘記過濾掉測試帳戶，即使技能提到了此規則。”

3. **返回 Claude A 尋求改進**：分享當前的 SKILL.md 並描述您觀察到的內容。問：“我在要求提供區域報告時注意到 Claude B 忘記過濾測試帳戶。技能中提到了過濾，但可能還不夠突出？”

4. **回顧 Claude A 的建議**：Claude A 可能建議重新組織以使規則更加突出，使用「必須過濾」而不是「始終過濾」等更強的語言，或重組工作流程部分。

5. **應用並測試更改**：使用 Claude A 的改進更新技能，然後根據類似的請求再次使用 Claude B 進行測試

6. **根據使用情況重複**：當遇到新場景時，繼續此觀察-優化-測試循環。每次迭代都會根據真實的代理行為而不是假設來提高技能。

**收集團隊回饋：**

1.與隊友分享技能並觀察其使用情況
2. 問：技能是否按預期激活？指示是否清楚？缺少什麼？
3. 納入反饋以解決您自己的使用模式中的盲點

**為什麼這種方法有效**：Claude A 瞭解代理需求，您提供領域專業知識，Claude B 透過實際使用揭示差距，迭代細化基於觀察到的行為而不是假設來提高技能。

### 觀察克勞德如何駕馭技能

當你迭代技能時，請注意克勞德在實踐中如何實際使用它們。注意：

* **意外的探索路徑**：克勞德是否以您沒有預料到的順序讀取文件？這可能表明您的結構並不像您想像的那麼直觀
* **錯過連接**：克勞德是否未能遵循對重要文件的引用？您的連結可能需要更明確或更突出
* **過度依賴某些部分**：如果克勞德重複讀取同一個文件，請考慮該內容是否應該放在主SKILL.md中
* **忽略的內容**：如果 Claude 從不訪問捆綁文件，則它可能是不必要的或在主要說明中信號不佳

基於這些觀察值而不是假設進行迭代。技能元資料中的「名稱」和「描述」尤其重要。克勞德在決定是否觸發技能來回應當前任務時使用這些。確保它們清楚地描述了該技能的用途以及何時使用該技能。

## 要避免的反模式

### 避免 Windows 風格的路徑

始終在檔案路徑中使用正斜槓，即使在 Windows 上也是如此：

* ✓ **好**：`scripts/helper.py`、`reference/guide.md`
* ✗ **避免**：`scripts\helper.py`、`reference\guide.md`

Unix 樣式路徑適用於所有平臺，而 Windows 樣式路徑會在 Unix 系統上導致錯誤。

### 避免提供太多選擇

除非必要，否則不要提出多種方法：

````markdown  theme={null}
**Bad example: Too many choices** (confusing):
"You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image, or..."

**Good example: Provide a default** (with escape hatch):
"Use pdfplumber for text extraction:
```蟒蛇
導入 pdfplumber```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead."
````

## 高級：可執行代碼的技能

以下部分重點介紹包含可執行腳本的技能。如果您的技能僅使用降價指令，請跳至[有效技能清單](#checklist-for- effective-skills)。

### 解決，不要棄踢

在為技能編寫腳本時，請處理錯誤情況，而不是向 Claude 下注。

**好例子：明確處理錯誤**：

```python  theme={null}
def process_file(path):
    """Process a file, creating it if it doesn't exist."""
    try:
        with open(path) as f:
            return f.read()
    except FileNotFoundError:
        # Create file with default content instead of failing
        print(f"File {path} not found, creating default")
        with open(path, 'w') as f:
            f.write('')
        return ''
    except PermissionError:
        # Provide alternative instead of failing
        print(f"Cannot access {path}, using default")
        return ''
```

**壞例子：對克勞德踢球**：

```python  theme={null}
def process_file(path):
    # Just fail and let Claude figure it out
    return open(path).read()
```

配置參數也應該合理化並記錄在案，以避免“巫術常數”（奧斯特豪特定律）。如果你不知道正確的值，克勞德將如何確定它？

**很好的例子：自我記錄**：

```python  theme={null}
# HTTP requests typically complete within 30 seconds
# Longer timeout accounts for slow connections
REQUEST_TIMEOUT = 30

# Three retries balances reliability vs speed
# Most intermittent failures resolve by the second retry
MAX_RETRIES = 3
```

**壞例子：幻數**：

```python  theme={null}
TIMEOUT = 47  # Why 47?
RETRIES = 5   # Why 5?
```

### 提供實用腳本

即使克勞德可以編寫腳本，預製腳本也具有以下優點：

**實用程式腳本的優點**：

* 比產生的程式碼更可靠
* 儲存令牌（無需在上下文中包含程式碼）
* 節省時間（無需產生程式碼）
* 確保不同用途的一致性

<img src="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=4bbc45f2c2e0bee9f2f0d5da669bad00" alt="將可執行腳本與指令文件捆綁在一起" data-og-width="2048" width="2048" data-og-height="1154" height="1154" data-path="images/agent-skills-executable-scripts.png" data-optimize="true" data-opv="3" srcset="https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=280&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=9a04e6535a8467bfeea492e517de389f 280w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=560&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=e49333ad90141af17c0d7651cca7216b 560w, https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=840&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=954265a5df52223d6572b6214168c428 840w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1100&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=2ff7a2d8f2a83ee8af132b29f10150fd 1100w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=1650&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=48ab96245e04077f4d15e9170e081cfb 1650w，https://mintcdn.com/anthropic-claude-docs/4Bny2bjzuGBK7o00/images/agent-skills-executable-scripts.png?w=2500&fit=max&auto=format&n=4Bny2bjzuGBK7o00&q=85&s=0301a6c8b3ee879497cc5b5483177c90 2500w"/>

上圖顯示了可執行腳本如何與指令文件一起工作。指令文件（forms.md）引用該腳本，Claude 可以執行它而無需將其內容加載到上下文中。

**重要區別**：在您的說明中明確克勞德是否應該：

* **執行腳本**（最常見）：“運行`analyze_form.py`以提取字段”
* **將其作為參考**（對於複雜的邏輯）：“請參閱`analyze_form.py`瞭解字段提取演算法”

對於大多數實用程序腳本，首選執行，因為它更可靠、更高效。有關腳本執行工作原理的詳細信息，請參閱下面的[運行時環境](#runtime-environment)部分。

**例子**：

````markdown  theme={null}
## Utility scripts

**analyze_form.py**: Extract all form fields from PDF

```巴什
蟒蛇 scripts/analyze_form.py input.pdf > fields.json```

Output format:
```json
{
  “字段名稱”：{“類型”：“文本”，“x”：100，“y”：200}，
  “簽名”：{“類型”：“sig”，“x”：150，“y”：500}
}```

**validate_boxes.py**: Check for overlapping bounding boxes

```巴什
蟒蛇 scripts/validate_boxes.py fields.json
# 回傳：「OK」或列出衝突```

**fill_form.py**: Apply field values to PDF

```巴什
蟒蛇 scripts/fill_form.py input.pdf fields.json output.pdf```
````

### 使用視覺分析

當輸入可以呈現為影像時，讓 Claude 分析它們：

````markdown  theme={null}
## Form layout analysis

1. Convert PDF to images:
   ```巴什
   蟒蛇 scripts/pdf_to_images.py form.pdf```

2. Analyze each page image to identify form fields
3. Claude can see field locations and types visually
````

<注意>
  在此示例中，您需要編寫`pdf_to_images.py` 腳本。
</注>

克勞德的視覺能力有助於理解佈局和結構。

### 建立可驗證的中間輸出

當克勞德執行複雜的、開放式的任務時，它可能會犯錯。 「計劃-驗證-執行」模式透過讓克勞德首先以結構化格式建立計劃，然後在執行之前使用腳本驗證該計劃，從而儘早捕獲錯誤。

**範例**：想像一下要求 Claude 根據電子表格更新 PDF 中的 50 個表單欄位。如果沒有驗證，Claude 可能會引用不存在的欄位、建立衝突的值、錯過必填欄位或錯誤地套用更新。

**解決方案**：使用上面顯示的工作流程模式（PDF 表單填寫），但添加一個中間 `changes.json` 文件，該文件在應用更改之前進行驗證。工作流程變為：分析 → **創建計劃文件** → **驗證計劃** → 執行 → 驗證。

**為什麼這種模式有效：**

* **儘早發現錯誤**：驗證在應用程式變更之前發現問題
* **機器可驗證**：腳本提供客觀驗證
* **可逆規劃**：克勞德可以在不觸及原始計劃的情況下迭代計劃
* **清晰偵錯**：錯誤訊息指向特定問題

**何時使用**：批量操作、破壞性更改、複雜的驗證規則、高風險操作。

**實作提示**：使用特定的錯誤訊息（例如「未找到欄位『signature\_date』。可用欄位：customer\_name、order\_total、signature\_date\_signed」）使驗證腳本變得詳細，以協助 Claude 解決問題。

### 包依賴項

技能在代碼執行環境中運行，具有特定於平臺的限制：

* **claude.ai**：可以從 npm 和 PyPI 安裝包並從 GitHub 存儲庫中提取
* **Anthropic API**：沒有網絡訪問權限，也沒有運行時包安裝

列出 SKILL.md 中所需的軟件包，並驗證它們在[代碼執行工具文檔](/en/docs/agents-and-tools/tool-use/code-execution-tool)中是否可用。

### 運行時環境

技能在具有檔案系統存取、bash 命令和程式碼執行功能的程式碼執行環境中運行。有關此架構的概念說明，請參閱概述中的[技能架構](/en/docs/agents-and-tools/agent-skills/overview#the-skills-architecture)。

**這如何影響您的創作：**

**克勞德如何獲得技能：**

1. **元資料預先載入**：啟動時，所有技能的 YAML frontmatter 中的名稱和描述都會載入到系統提示符號中
2. **檔案按需讀取**：Claude 在需要時使用 bash Read 工具從檔案系統存取 SKILL.md 和其他文件
3. **高效執行腳本**：實用程式腳本可以透過 bash 執行，而無需將其完整內容載入到上下文中。只有腳本的輸出消耗令牌
4. **大文件沒有上下文懲罰**：參考文件、資料或文件在實際讀取前不會消耗上下文標記

* **文件路徑很重要**：Claude 像文件系統一樣導航您的技能目錄。使用正斜槓 (`reference/guide.md`)，而不是反斜槓
* **以描述性方式命名文件**：使用指示內容的名稱：`form_validation_rules.md`，而不是 `doc2.md`
* **組織發現**：按域或功能構建目錄
  * 好：`reference/finance.md`、`reference/sales.md`
  * 不好：`docs/file1.md`、`docs/file2.md`
* **捆綁全面的資源**：包括完整的API文檔、廣泛的示例、大型數據集；在訪問之前沒有上下文懲罰
* **首選確定性操作的腳本**：編寫`validate_form.py`而不是要求Claude生成驗證代碼
* **明確執行意圖**：
  *“運行`analyze_form.py`以提取字段”（執行）
  *“提取算法參見`analyze_form.py`”（作為參考閱讀）
* **測試文件訪問模式**：通過測試真實請求來驗證 Claude 是否可以導航您的目錄結構

**範例：**

```
bigquery-skill/
├── SKILL.md (overview, points to reference files)
└── reference/
    ├── finance.md (revenue metrics)
    ├── sales.md (pipeline data)
    └── product.md (usage analytics)
```

當用戶詢問收入時，Claude 讀取 SKILL.md，看到對 `reference/finance.md` 的引用，並調用 bash 來讀取該文件。 sales.md 和product.md 文件保留在文件系統上，在需要之前消耗零上下文令牌。這種基於文件系統的模型使得漸進式公開成為可能。克勞德可以導航並有選擇地加載每個任務所需的內容。

有關技術架構的完整詳細信息，請參閱技能概述中的[技能如何運作](/en/docs/agents-and-tools/agent-skills/overview#how-skills-work)。

### MCP 工具參考

如果您的技能使用 MCP（模型上下文協定）工具，請務必使用完全限定的工具名稱，以避免「找不到工具」錯誤。

**格式**：`ServerName:tool_name`

**例子**：

```markdown  theme={null}
Use the BigQuery:bigquery_schema tool to retrieve table schemas.
Use the GitHub:create_issue tool to create issues.
```

在哪裡：

* `BigQuery` 和 `GitHub` 是 MCP 服務器名稱
* `bigquery_schema` 和 `create_issue` 是這些服務器中的工具名稱

如果沒有服務器前綴，Claude 可能無法找到該工具，特別是當有多個 MCP 服務器可用時。

### 避免假設工具已安裝

不要假設軟體包可用：

````markdown  theme={null}
**Bad example: Assumes installation**:
"Use the pdf library to process the file."

**Good example: Explicit about dependencies**:
"Install required package: `pip install pypdf`

Then use it:
```蟒蛇
從 pypdf 導入 PdfReader
讀者 = PdfReader("file.pdf")```"
````

## 技術說明

### YAML frontmatter 要求

SKILL.md frontmatter 僅包含 `name`（最多 64 個字元）和 `description`（最多 1024 個字元）欄位。有關完整的結構詳細信息，請參閱[技能概述](/en/docs/agents-and-tools/agent-skills/overview#skill-struct)。

### 代幣預算

將 SKILL.md 正文保持在 500 行以下，以獲得最佳效能。如果您的內容超出此範圍，請使用前面所述的漸進式揭露模式將其分割為單獨的文件。有關架構詳細信息，請參閱[技能概述](/en/docs/agents-and-tools/agent-skills/overview#how-skills-work)。

## 有效技能清單

在分享技能之前，請驗證：

### 核心品質

* [ ] 描述具體並包含關鍵術語
* [ ] 描述包含技能的用途與使用時間
* [ ] SKILL.md正文低於500行
* [ ] 其他詳細資訊位於單獨的文件中（如果需要）
* [ ] 沒有時間敏感資訊（或在「舊模式」部分）
* [ ] 始終使用一致的術語
* [ ] 例子是具體的，而不是抽象的
* [ ] 文件引用深一層
* [ ] 適當使用漸進式揭露
* [ ] 工作流程步驟清晰

### 代碼和腳本

* [ ] 腳本解決問題而不是向 Claude 下注
* [ ] 錯誤處理是明確且有幫助的
* [ ] 沒有「巫毒常數」（所有數值皆合理）
* [ ] 說明中列出了所需的軟體包並驗證為可用
* [ ] 腳本有清晰的文檔
* [ ] 沒有 Windows 風格的路徑（全部都是正斜線）
* [ ] 關鍵操作的驗證/驗證步驟
* [ ] 包含針對品質關鍵任務的回饋循環

### 測試

* [ ] 至少創建了三個評估
* [ ] 使用 Haiku、Sonnet 和 Opus 進行測試
* [ ] 經過真實使用場景測試
* [ ] 納入團隊反饋（如果適用）

## 後續步驟

<卡組列={2}>
  <Card title="代理技能入門" icon="rocket" href="/en/docs/agents-and-tools/agent-skills/quickstart">
    創建你的第一個技能
  </卡>

<Card title="使用克勞德代碼技能" icon="terminal" href="/en/docs/claude-code/skills">
    在 Claude Code 中創建和管理技能
  </卡>

<Card title="使用 API 技能" icon="code" href="/en/api/skills-guide">
    以編程方式上傳和使用技能
  </卡>
</卡組>