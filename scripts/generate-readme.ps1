#Requires -Version 5.1
param(
    [string]$DataPath,
    [string]$ReadmePath
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($DataPath)) {
    $DataPath = Join-Path $repoRoot 'data\skills.json'
}
if ([string]::IsNullOrWhiteSpace($ReadmePath)) {
    $ReadmePath = Join-Path $repoRoot 'README.md'
}

$categories = @(
    '热门网红 / 博主 Skill',
    '商业人物 / 创业者 Skill',
    '教育 / 职业导师 Skill',
    '情感人物 / 关系人格 Skill',
    '职场角色人格 Skill',
    '玄学人物 / 神秘人格 Skill',
    '经典人格 / 自我镜像 Skill',
    '新收录 / 待观察'
)

$categoryBlurbs = @{
    '热门网红 / 博主 Skill' = '围绕中文互联网博主、创作者与高辨识度内容人格的项目。'
    '商业人物 / 创业者 Skill' = '围绕创业者、投资人、产品人和商业判断框架的人设型项目。'
    '教育 / 职业导师 Skill' = '围绕教学、学习陪练、职业辅导与导师风格的人格化项目。'
    '情感人物 / 关系人格 Skill' = '围绕前任、恋爱陪伴、关系复盘与情绪消费的人设型项目。'
    '职场角色人格 Skill' = '围绕老板、同事、CEO、面试官等工作场景角色的项目。'
    '玄学人物 / 神秘人格 Skill' = '围绕命理、塔罗、周易、赛博半仙和神秘人格体验的项目。'
    '经典人格 / 自我镜像 Skill' = '围绕数字分身、自我镜像、人格框架和认知蒸馏的项目。'
    '新收录 / 待观察' = '题材贴题但仍需继续观察形态、质量或长期维护状态的项目。'
}

$entryKindLabels = @{
    'skill' = '标准Skill'
    'persona_repo' = '人格化Repo'
    'watchlist' = '待观察'
}

$statusLabels = @{
    'active' = '活跃'
    'watchlist' = '观察中'
    'seed' = '种子'
}

function Get-Anchor {
    param([string]$Text)

    $anchor = $Text.ToLowerInvariant()
    $anchor = $anchor.Replace(' / ', '--')
    $anchor = $anchor.Replace(' ', '-')
    $anchor = $anchor.Replace('.', '')
    return $anchor
}

function Get-StarText {
    param($Stars)

    if ($null -eq $Stars) {
        return '未标注'
    }

    return [string]$Stars
}

function Format-Entry {
    param($Entry)

    $kindLabel = $entryKindLabels[[string]$Entry.entry_kind]
    $statusLabel = $statusLabels[[string]$Entry.status]
    $tags = @($Entry.tags) | ForEach-Object { '`{0}`' -f $_ }
    $tagLine = if ($tags.Count -gt 0) { $tags -join ' ' } else { '无' }
    $stars = Get-StarText $Entry.stars

    return @(
        ('- [{0}]({1}) `{2}` `{3}`' -f $Entry.name, $Entry.repo_url, $kindLabel, $statusLabel)
        ('  {0}' -f $Entry.description)
        ('  标签：{0} | Stars：{1}' -f $tagLine, $stars)
    )
}

if (-not (Test-Path -LiteralPath $DataPath)) {
    throw "Missing data file: $DataPath"
}

$entries = Get-Content -LiteralPath $DataPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($entries -isnot [System.Array]) {
    $entries = @($entries)
}

$featuredEntries = @($entries | Where-Object { $_.featured } | Select-Object -First 8)
$skillCount = @($entries | Where-Object { $_.entry_kind -eq 'skill' }).Count
$personaRepoCount = @($entries | Where-Object { $_.entry_kind -eq 'persona_repo' }).Count
$watchlistCount = @($entries | Where-Object { $_.entry_kind -eq 'watchlist' }).Count

$lines = New-Object System.Collections.Generic.List[string]

$lines.Add('# 人物 / 角色人格 Skill 图鉴')
$lines.Add('')
$lines.Add('![License](https://img.shields.io/badge/license-MIT-green.svg) ![Status](https://img.shields.io/badge/status-curated-blue.svg)')
$lines.Add('')
$lines.Add('> 一个 GitHub 原生目录，持续收集中文圈 Persona / Character / Skill / 数字分身 / 玄学娱乐相关开源项目。')
$lines.Add('')
$lines.Add(("当前收录：**{0}** 项 ｜ 标准 Skill：**{1}** ｜ 人格化 Repo：**{2}** ｜ 待观察：**{3}**" -f $entries.Count, $skillCount, $personaRepoCount, $watchlistCount))
$lines.Add('')
$lines.Add('> 持续更新中，欢迎通过 Issue / Pull Request 补充新条目。')
$lines.Add('')
$lines.Add('## 项目介绍')
$lines.Add('')
$lines.Add('- 定位：做一个 GitHub 原生的大而全目录，而不是短期热榜。')
$lines.Add('- 主轴：以国内中文圈的人设 / 角色 / 人格 / 玄学娱乐项目为主，少量补充高辨识度的全球知名人物项目。')
$lines.Add('- 数据：`data/skills.json` 是唯一数据源，`README.md` 由脚本从数据生成。')
$lines.Add('- 口径：标准 Skill 优先，也收少量高质量人格化 AI repo，但会通过条目类型显式区分。')
$lines.Add('')
$lines.Add('## 快速导航')
$lines.Add('')
$lines.Add('- [精选推荐](#精选推荐)')
foreach ($category in $categories) {
    $lines.Add(("- [{0}](#{1})" -f $category, (Get-Anchor $category)))
}
$lines.Add('- [维护方式](#维护方式)')
$lines.Add('- [收录标准](#收录标准)')
$lines.Add('- [投稿方式](#投稿方式)')
$lines.Add('- [更新记录](./CHANGELOG.md)')
$lines.Add('- [免责声明](#免责声明)')
$lines.Add('')
$lines.Add('## 收录范围 / 不收录范围')
$lines.Add('')
$lines.Add('**收录：**')
$lines.Add('- 明显具备人物感、角色感、人格视角或神秘人格体验的 GitHub 公开项目。')
$lines.Add('- 标准 `Skill / Agent Skill` 项目。')
$lines.Add('- 少量高质量人格化 AI repo，作为目录补充。')
$lines.Add('')
$lines.Add('**不收录：**')
$lines.Add('- 纯工具链、纯 workflow、纯工程脚手架。')
$lines.Add('- 没有人设叙事、只有功能包装的普通 AI 仓库。')
$lines.Add('- 与本库主轴无关的泛资源集合。')
$lines.Add('')
$lines.Add('## 精选推荐')
$lines.Add('')
$lines.Add('第一次来建议先看这些代表性条目。它们只负责导览，不代表完整目录。')
$lines.Add('')
foreach ($entry in $featuredEntries) {
    foreach ($line in (Format-Entry $entry)) {
        $lines.Add($line)
    }
    $lines.Add('')
}

foreach ($category in $categories) {
    $lines.Add(("## {0}" -f $category))
    $lines.Add('')
    $lines.Add($categoryBlurbs[$category])
    $lines.Add('')

    $categoryEntries = @(
        $entries |
            Where-Object { $_.category -eq $category } |
            Sort-Object -Property `
                @{ Expression = { if ($_.featured) { 0 } else { 1 } } }, `
                @{ Expression = { if ($null -eq $_.stars) { -1 } else { [int]$_.stars } }; Descending = $true }, `
                @{ Expression = { [string]$_.name } }
    )

    if ($categoryEntries.Count -eq 0) {
        $lines.Add('（本分类待补充。）')
        $lines.Add('')
        continue
    }

    foreach ($entry in $categoryEntries) {
        foreach ($line in (Format-Entry $entry)) {
            $lines.Add($line)
        }
        $lines.Add('')
    }
}

$lines.Add('## 维护方式')
$lines.Add('')
$lines.Add('- 维护入口：条目数据统一维护在 `data/skills.json`。')
$lines.Add('- 校验命令：修改数据后先运行 `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`。')
$lines.Add('- 生成命令：数据变更后再运行 `powershell -ExecutionPolicy Bypass -File .\scripts\generate-readme.ps1` 重建首页。')
$lines.Add('- 推荐项目：如果你只想推荐仓库，请直接使用 GitHub Issue 模板。')
$lines.Add('- 直接投稿：如果你已经准备好字段和描述，可以直接提交 Pull Request。')
$lines.Add('- 变更记录：重要目录调整和仓库维护更新记录在 `CHANGELOG.md`。')
$lines.Add('')

$lines.Add('## 收录标准')
$lines.Add('')
$lines.Add('- 只收 GitHub 上公开可访问、且具备明确人设或角色消费属性的项目。')
$lines.Add('- 优先收录可直接安装、可直接体验、可明显看出人格视角的项目。')
$lines.Add('- 允许少量人格化 AI repo 作为补充，但会显式标注为 `人格化Repo`。')
$lines.Add('- 如项目仍在试验期、形态偏宽或边界模糊，可先进入 `新收录 / 待观察`。')
$lines.Add('')
$lines.Add('## 投稿方式')
$lines.Add('')
$lines.Add('欢迎通过 Issue 推荐项目，或通过 Pull Request 直接补充新条目。投稿前请先：')
$lines.Add('')
$lines.Add('如果只是推荐项目，请使用 GitHub 的 `推荐新条目` Issue 模板。')
$lines.Add('')
$lines.Add('1. 按 `CONTRIBUTING.md` 补齐字段。')
$lines.Add('2. 运行 `powershell -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1`。')
$lines.Add('3. 如需重建首页，运行 `powershell -ExecutionPolicy Bypass -File .\scripts\generate-readme.ps1`。')
$lines.Add('')
$lines.Add('## 免责声明')
$lines.Add('')
$lines.Add('本仓库仅为公开信息整理与链接索引，不对第三方仓库内容的可用性、合规性和长期维护状态做保证。使用前请自行阅读对方仓库说明、许可证与风险提示。')
$lines.Add('')

$content = ($lines -join [Environment]::NewLine) + [Environment]::NewLine
Set-Content -LiteralPath $ReadmePath -Value $content -Encoding UTF8
Write-Host "README generated: $ReadmePath" -ForegroundColor Green
