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

function Escape-TableText {
    param([string]$Text)

    if ($null -eq $Text) {
        return ''
    }

    return $Text.Replace('|', '\|').Replace([Environment]::NewLine, '<br>')
}

function Get-DisplayName {
    param([string]$Name)

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return ''
    }

    $displayName = [regex]::Replace($Name, '\.skill', '', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $displayName = [regex]::Replace($displayName, '\s{2,}', ' ')

    return $displayName.Trim()
}

function Format-ListEntry {
    param($Entry)

    $displayName = Get-DisplayName ([string]$Entry.name)

    return ('- [{0}]({1})' -f `
        $displayName,
        $Entry.repo_url)
}

if (-not (Test-Path -LiteralPath $DataPath)) {
    throw "Missing data file: $DataPath"
}

$entries = Get-Content -LiteralPath $DataPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($entries -isnot [System.Array]) {
    $entries = @($entries)
}

$skillCount = @($entries | Where-Object { $_.entry_kind -eq 'skill' }).Count
$personaRepoCount = @($entries | Where-Object { $_.entry_kind -eq 'persona_repo' }).Count
$watchlistCount = @($entries | Where-Object { $_.entry_kind -eq 'watchlist' }).Count

$lines = New-Object System.Collections.Generic.List[string]

$lines.Add('# 人物 / 角色人格 Skill 开源合集')
$lines.Add('')
$lines.Add('![License](https://img.shields.io/badge/license-MIT-green.svg) ![Status](https://img.shields.io/badge/status-curated-blue.svg)')
$lines.Add('')
$lines.Add('> 一个 GitHub 原生目录，持续收集中文圈 Persona / Character / Skill / 数字分身 / 玄学娱乐相关开源项目。')
$lines.Add('')
$lines.Add(("当前收录：**{0}** 项 ｜ 标准 Skill：**{1}** ｜ 人格化 Repo：**{2}** ｜ 待观察：**{3}**" -f $entries.Count, $skillCount, $personaRepoCount, $watchlistCount))
$lines.Add('')
$lines.Add('> 持续更新中，欢迎通过 Issue / Pull Request 补充新条目。')
$lines.Add('')
$lines.Add('## 快速导航')
$lines.Add('')
foreach ($category in $categories) {
    $lines.Add(("- [{0}](#{1})" -f $category, (Get-Anchor $category)))
}
$lines.Add('- [补充说明](#补充说明)')
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
foreach ($category in $categories) {
    $lines.Add(("## {0}" -f $category))
    $lines.Add('')
    $lines.Add($categoryBlurbs[$category])
    $lines.Add('')

    $categoryEntries = @(
        $entries |
            Where-Object { $_.category -eq $category } |
            Sort-Object -Property `
                @{ Expression = { if ($null -eq $_.stars) { -1 } else { [int]$_.stars } }; Descending = $true }, `
                @{ Expression = { [string]$_.name } }
    )

    if ($categoryEntries.Count -eq 0) {
        $lines.Add('（本分类待补充。）')
        $lines.Add('')
        continue
    }

    foreach ($entry in $categoryEntries) {
        $lines.Add((Format-ListEntry $entry))
    }

    $lines.Add('')
}

$lines.Add('## 补充说明')
$lines.Add('')
$lines.Add('- 本库优先收录具有人设、角色感、数字分身或玄学娱乐属性的 GitHub 项目，少量人格化 AI Repo 作为补充。')
$lines.Add('- 推荐项目请提 Issue，直接补充条目请提交 Pull Request，细则见 `CONTRIBUTING.md`。')
$lines.Add('- 维护和目录变更记录见 `CHANGELOG.md`。')
$lines.Add('')
$lines.Add('## 免责声明')
$lines.Add('')
$lines.Add('本仓库仅为公开信息整理与链接索引，不对第三方仓库内容的可用性、合规性和长期维护状态做保证。使用前请自行阅读对方仓库说明、许可证与风险提示。')
$lines.Add('')

$content = ($lines -join [Environment]::NewLine) + [Environment]::NewLine
Set-Content -LiteralPath $ReadmePath -Value $content -Encoding UTF8
Write-Host "README generated: $ReadmePath" -ForegroundColor Green
