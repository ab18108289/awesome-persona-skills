# 人物 / 角色人格 Skill 合集 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a GitHub-native repository that curates 100+ high-value persona-style Skill projects with a classification-first README and maintainable source data.

**Architecture:** Keep the repository simple and GitHub-first: `README.md` is the public landing page, `data/skills.json` is the structured source of truth for entries, and `CONTRIBUTING.md` defines future submissions. Use a tiny PowerShell validator so the collection can scale without drifting into duplicate links, inconsistent categories, or malformed JSON.

**Tech Stack:** Markdown, JSON, PowerShell

---

## File Structure

- `README.md`
  - Public homepage for users.
  - Contains the repository title, positioning, quick navigation, featured entries, full categorized list, update section, standards, and submission guidance.
- `data/skills.json`
  - Structured list of all persona-style Skill entries.
  - Stores normalized fields such as name, category, description, repository URL, tags, and optional stars.
- `CONTRIBUTING.md`
  - Submission rules and formatting guide for future contributors.
- `scripts/validate-skills.ps1`
  - Small maintainer utility that validates JSON format, required fields, duplicate repository URLs, and category validity.

## Task 1: Create Repository Skeleton

**Files:**
- Create: `README.md`
- Create: `data/skills.json`
- Create: `CONTRIBUTING.md`
- Create: `scripts/validate-skills.ps1`

- [ ] **Step 1: Create the initial README skeleton**

```md
# 人物 / 角色人格 Skill 合集

> 系统收录 GitHub 上热门人物、网红博主、强人设角色与高需求人格 Skill，持续更新。

## 项目介绍

这个仓库专注收集 GitHub 上具备明确人物感、人设感、角色视角的 Skill 项目。

收录范围包含两类：

- 真实人物 Skill：网红、博主、公众人物、导师、创业者等
- 角色人格 Skill：老板、同事、前任、自己、大师、月老等

不收纯工具链、纯 workflow、纯工程型 Skill。

## 快速导航

- [热门网红 / 博主 Skill](#热门网红--博主-skill)
- [商业人物 / 创业者 Skill](#商业人物--创业者-skill)
- [教育 / 职业导师 Skill](#教育--职业导师-skill)
- [情感人物 / 关系人格 Skill](#情感人物--关系人格-skill)
- [职场角色人格 Skill](#职场角色人格-skill)
- [玄学人物 / 神秘人格 Skill](#玄学人物--神秘人格-skill)
- [经典人格 / 自我镜像 Skill](#经典人格--自我镜像-skill)
- [新收录 / 待观察](#新收录--待观察)

## 精选推荐

## 热门网红 / 博主 Skill

## 商业人物 / 创业者 Skill

## 教育 / 职业导师 Skill

## 情感人物 / 关系人格 Skill

## 职场角色人格 Skill

## 玄学人物 / 神秘人格 Skill

## 经典人格 / 自我镜像 Skill

## 新收录 / 待观察

## 收录标准

## 投稿方式

## 免责声明
```

- [ ] **Step 2: Create the initial structured data file**

```json
[
  {
    "name": "示例.skill",
    "category": "热门网红 / 博主 Skill",
    "type": "真实人物",
    "description": "一句话说明这个 skill 模拟的人物视角与适用场景。",
    "repo_url": "https://github.com/example/example-skill",
    "tags": ["人物", "热门", "国内"],
    "stars": null,
    "status": "seed"
  }
]
```

- [ ] **Step 3: Create the contribution guide skeleton**

```md
# 投稿指南

欢迎补充新的「人物 / 角色人格 Skill」项目。

## 收录要求

- 必须是公开可访问的 GitHub 仓库
- 必须具备明确的人物感、人设感或角色视角
- 不收纯工具型、纯 workflow、纯工程型项目

## 投稿格式

- 名称：
- 类型：真实人物 / 角色人格
- 分类：
- 一句话介绍：
- GitHub 链接：
- 推荐理由：
```

- [ ] **Step 4: Create the validator script**

```powershell
$dataPath = Join-Path $PSScriptRoot "..\\data\\skills.json"
$raw = Get-Content $dataPath -Raw
$items = $raw | ConvertFrom-Json

$allowedCategories = @(
  "热门网红 / 博主 Skill",
  "商业人物 / 创业者 Skill",
  "教育 / 职业导师 Skill",
  "情感人物 / 关系人格 Skill",
  "职场角色人格 Skill",
  "玄学人物 / 神秘人格 Skill",
  "经典人格 / 自我镜像 Skill",
  "新收录 / 待观察"
)

foreach ($item in $items) {
  if (-not $item.name) { throw "Missing name" }
  if (-not $item.category) { throw "Missing category" }
  if (-not $item.description) { throw "Missing description" }
  if (-not $item.repo_url) { throw "Missing repo_url" }
  if ($allowedCategories -notcontains $item.category) {
    throw "Invalid category: $($item.category)"
  }
}

$duplicateUrls = $items.repo_url | Group-Object | Where-Object { $_.Count -gt 1 }
if ($duplicateUrls) {
  throw "Duplicate repo_url found: $($duplicateUrls.Name -join ', ')"
}

Write-Host "skills.json validation passed with $($items.Count) entries."
```

- [ ] **Step 5: Run the validator against the seed file**

Run: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`

Expected: PASS with output like `skills.json validation passed with 1 entries.`

## Task 2: Seed the Approved Existing Entries

**Files:**
- Modify: `data/skills.json`
- Modify: `README.md`

- [ ] **Step 1: Replace the seed JSON entry with the already approved starter set**

```json
[
  {
    "name": "赛博算命.skill",
    "category": "玄学人物 / 神秘人格 Skill",
    "type": "角色人格",
    "description": "专业八字排盘与命理分析，适合做赛博命理咨询与传统文化体验。",
    "repo_url": "https://github.com/jinchenma94/bazi-skill",
    "tags": ["角色", "玄学", "热门", "国内"],
    "stars": null,
    "status": "approved"
  },
  {
    "name": "老板.skill",
    "category": "职场角色人格 Skill",
    "type": "角色人格",
    "description": "从老板视角给方案反馈、挑问题和提建议，适合工作复盘与方案审视。",
    "repo_url": "https://github.com/vogtsw/boss-skills",
    "tags": ["角色", "职场", "热门"],
    "stars": null,
    "status": "approved"
  },
  {
    "name": "户晨风.skill",
    "category": "热门网红 / 博主 Skill",
    "type": "真实人物",
    "description": "用现实主义视角分析消费、城市选择与人生决策，适合去滤镜判断。",
    "repo_url": "https://github.com/Janlaywss/hu-chenfeng-skill",
    "tags": ["人物", "博主", "热门", "国内"],
    "stars": null,
    "status": "approved"
  }
]
```

- [ ] **Step 2: Expand the JSON block above into the full approved starter set**

Add the remaining approved entries from the design decisions:

- `月老·姻缘测算.skill`
- `奇门遁甲、紫微斗数.skill`
- `大师.skill`
- `X导师.skill`
- `同事.skill`
- `女娲.skill`
- `自己.skill`
- `前任.skill`
- `博主.skill`
- `童锦程.skill`
- `张雪峰.skill`
- `张一鸣.skill`

Use the same normalized field structure from Step 1 for each entry.

- [ ] **Step 3: Validate the expanded JSON**

Run: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`

Expected: PASS with output showing the full starter count.

- [ ] **Step 4: Add a starter featured block to README using the same approved entries**

```md
## 精选推荐

- `户晨风.skill`
  用现实主义视角分析消费、城市选择与人生决策，适合去滤镜判断。
  GitHub: `https://github.com/Janlaywss/hu-chenfeng-skill`
  标签：`人物` `博主` `热门` `国内`

- `老板.skill`
  从老板视角给方案反馈、挑问题和提建议，适合工作复盘与方案审视。
  GitHub: `https://github.com/vogtsw/boss-skills`
  标签：`角色` `职场` `热门`

- `赛博算命.skill`
  专业八字排盘与命理分析，适合做赛博命理咨询与传统文化体验。
  GitHub: `https://github.com/jinchenma94/bazi-skill`
  标签：`角色` `玄学` `热门` `国内`
```

- [ ] **Step 5: Verify the README contains the expected major sections**

Run: `rg "^## " README.md`

Expected output includes:

- `## 项目介绍`
- `## 快速导航`
- `## 精选推荐`
- all 8 category headings
- `## 收录标准`
- `## 投稿方式`

## Task 3: Expand the Collection to 100+ Normalized Entries

**Files:**
- Modify: `data/skills.json`

- [ ] **Step 1: Fill category quotas in a controlled order**

Use this minimum target distribution:

- 热门网红 / 博主 Skill: 20+
- 商业人物 / 创业者 Skill: 12+
- 教育 / 职业导师 Skill: 12+
- 情感人物 / 关系人格 Skill: 18+
- 职场角色人格 Skill: 16+
- 玄学人物 / 神秘人格 Skill: 12+
- 经典人格 / 自我镜像 Skill: 10+
- 新收录 / 待观察: overflow bucket as needed

- [ ] **Step 2: Add entries in batches of 10-15 and validate after each batch**

For each batch:

1. Search for persona-style GitHub repositories.
2. Normalize the entry into the JSON schema.
3. Run the validator before adding the next batch.

Run after each batch: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`

Expected: PASS with the updated entry count and no duplicate repository URLs.

- [ ] **Step 3: Keep descriptions consistent and non-hypey**

Every entry description must answer:

- who the persona is
- what the skill is useful for

Example acceptable pattern:

```json
{
  "name": "张雪峰.skill",
  "category": "教育 / 职业导师 Skill",
  "type": "真实人物",
  "description": "直爽现实的教育与职业规划导师，适合做考研、就业与路径选择判断。",
  "repo_url": "https://github.com/alchaincyf/zhangxuefeng-skill",
  "tags": ["人物", "导师", "教育", "热门", "国内"],
  "stars": null,
  "status": "approved"
}
```

- [ ] **Step 4: Reject off-topic repositories immediately**

Do not add:

- pure toolchains
- workflow collections
- prompt packs with no clear persona framing
- inactive repositories with no real persona-style positioning

- [ ] **Step 5: Verify the count reaches 100+**

Run: `powershell -Command "((Get-Content .\\data\\skills.json -Raw | ConvertFrom-Json).Count)"`

Expected: a value of `100` or higher.

## Task 4: Build the Full README from the Normalized Data

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Write the introduction and repository positioning**

```md
## 项目介绍

这个仓库专注收集 GitHub 上具备明确人物感、人设感、角色视角的 Skill 项目。

相比只做热榜，这个仓库更强调：

- 分类清晰
- 持续更新
- 人物 / 人设边界明确
- 尽可能全的收录

如果你想找热门网红 Skill、角色人格 Skill、情感关系人格、职场人设或玄学人物 Skill，这里会持续补齐。
```

- [ ] **Step 2: Keep the featured section short**

Limit the featured section to 12-18 entries max, grouped under:

```md
### 最火人物 Skill

### 最有意思的角色人格 Skill

### 近期新增
```

- [ ] **Step 3: Render the full categorized list**

Use the standard item format everywhere:

```md
- `前任.skill`
  从前任视角复盘关系与情绪拉扯，适合做感情分析与关系复盘。
  GitHub: `https://github.com/therealXiaomanChu/ex-skill`
  标签：`角色` `情感` `热门`
```

- [ ] **Step 4: Add repository standards and boundaries**

```md
## 收录标准

- 收录 GitHub 上公开可访问的人物 / 人设 / 角色视角 Skill 项目
- 优先收录主题明确、定位清晰、实际可用、具备代表性的仓库
- 兼顾热度、趣味性、实用性和传播性
- 不收纯工具型、纯工程型、纯 workflow 型项目
```

- [ ] **Step 5: Verify the README feels classification-first**

Run: `rg "^## " README.md`

Expected: `快速导航` appears before `精选推荐`, and all 8 category sections are present before the repository standards and submission sections.

## Task 5: Add Contribution and Maintenance Rules

**Files:**
- Modify: `CONTRIBUTING.md`
- Modify: `README.md`

- [ ] **Step 1: Expand CONTRIBUTING into a reusable submission guide**

```md
## 投稿检查清单

- [ ] 是公开可访问的 GitHub 仓库
- [ ] 有明确人物感 / 人设感 / 角色视角
- [ ] 不属于纯工具型、纯 workflow、纯工程型项目
- [ ] 提供一句话介绍
- [ ] 提供推荐理由
```

- [ ] **Step 2: Link the contribution guide from README**

```md
## 投稿方式

欢迎补充更多人物 / 角色人格 Skill。

请参考：`CONTRIBUTING.md`
```

- [ ] **Step 3: Add a lightweight maintenance note**

```md
## 免责声明

本仓库为公开资料整理，不代表对收录项目内容的立场背书。

项目热度、stars 与内容状态会随时间变化，欢迎补充修正。
```

- [ ] **Step 4: Re-run JSON validation**

Run: `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`

Expected: PASS with no missing fields or duplicates.

- [ ] **Step 5: Final content QA**

Run:

- `powershell -Command "((Get-Content .\\data\\skills.json -Raw | ConvertFrom-Json).Count)"`
- `rg "^## " README.md`
- `rg "workflow|engineering|toolchain" README.md`

Expected:

- skill count is `100` or higher
- all expected README sections exist
- no accidental repository positioning drift toward tool/workflow collection language

## Self-Review

### Spec coverage

- Project positioning is covered by Task 1 and Task 4.
- Classification-first README structure is covered by Task 1 and Task 4.
- 8-category taxonomy is enforced in Task 1 validator and Task 3 expansion.
- Persona-only inclusion boundary is enforced in Task 3 and Task 5.
- 100+ collection goal is enforced in Task 3 and final QA.
- Submission and maintenance flow is covered by Task 5.

### Placeholder scan

No `TBD`, `TODO`, or undefined implementation placeholders remain. Each task has concrete files, concrete snippets, and concrete validation commands.

### Type consistency

The normalized data structure is consistent across tasks:

- `name`
- `category`
- `type`
- `description`
- `repo_url`
- `tags`
- `stars`
- `status`

No later task changes these field names.
