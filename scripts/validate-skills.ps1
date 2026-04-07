#Requires -Version 5.1
param(
    [string]$DataPath
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($DataPath)) {
    $dataPath = Join-Path (Join-Path $repoRoot 'data') 'skills.json'
} else {
    $dataPath = $DataPath
}

$validCategories = @(
    '热门网红 / 博主 Skill',
    '商业人物 / 创业者 Skill',
    '教育 / 职业导师 Skill',
    '情感人物 / 关系人格 Skill',
    '职场角色人格 Skill',
    '玄学人物 / 神秘人格 Skill',
    '经典人格 / 自我镜像 Skill',
    '新收录 / 待观察'
)
$validSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($category in $validCategories) {
    [void]$validSet.Add($category)
}

$validEntryKinds = @(
    'skill',
    'persona_repo',
    'watchlist'
)
$validEntryKindSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($entryKind in $validEntryKinds) {
    [void]$validEntryKindSet.Add($entryKind)
}

$validStatuses = @(
    'active',
    'watchlist',
    'seed'
)
$validStatusSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($status in $validStatuses) {
    [void]$validStatusSet.Add($status)
}

if (-not (Test-Path -LiteralPath $dataPath)) {
    Write-Error "Missing file: $dataPath"
    exit 1
}

$raw = Get-Content -LiteralPath $dataPath -Raw -Encoding UTF8
try {
    $data = $raw | ConvertFrom-Json
} catch {
    Write-Error "Invalid JSON: $($_.Exception.Message)"
    exit 1
}

if ($null -eq $data) {
    Write-Error 'JSON root is null.'
    exit 1
}

$entries = @()
if ($data -is [System.Array]) {
    $entries = @($data)
} else {
    $entries = @($data)
}
$errors = New-Object System.Collections.Generic.List[string]
$urlToIndices = @{}
$nameToIndices = @{}

for ($i = 0; $i -lt $entries.Count; $i++) {
    $entry = $entries[$i]
    $prefix = "Entry[$i]"

    if ($null -eq $entry) {
        $errors.Add("$prefix : entry is null")
        continue
    }

    $requiredFields = @('name', 'category', 'type', 'description', 'repo_url', 'tags', 'status', 'entry_kind', 'featured')
    foreach ($field in $requiredFields) {
        if (-not ($entry.PSObject.Properties.Name -contains $field)) {
            $errors.Add("$prefix : missing required field '$field'")
            continue
        }

        $value = $entry.$field
        if ($null -eq $value -or ($value -is [string] -and [string]::IsNullOrWhiteSpace($value))) {
            $errors.Add("$prefix : required field '$field' is empty")
        }
    }

    $name = [string]$entry.name
    if (-not [string]::IsNullOrWhiteSpace($name)) {
        $normalizedName = $name.Trim().ToLowerInvariant()
        if (-not $nameToIndices.ContainsKey($normalizedName)) {
            $nameToIndices[$normalizedName] = New-Object System.Collections.Generic.List[int]
        }
        $nameToIndices[$normalizedName].Add($i)
    }

    $category = [string]$entry.category
    if (-not [string]::IsNullOrWhiteSpace($category) -and -not $validSet.Contains($category)) {
        $errors.Add("$prefix : invalid category '$category'")
    }

    $repoUrl = [string]$entry.repo_url
    if (-not [string]::IsNullOrWhiteSpace($repoUrl)) {
        if ($repoUrl -notmatch '^https://github\.com/[^/\s]+/[^/\s]+/?$') {
            $errors.Add("$prefix : repo_url must be a GitHub repository HTTPS URL")
        }
        if (-not $urlToIndices.ContainsKey($repoUrl)) {
            $urlToIndices[$repoUrl] = New-Object System.Collections.Generic.List[int]
        }
        $urlToIndices[$repoUrl].Add($i)
    }

    $tags = @($entry.tags)
    if ($tags.Count -eq 0) {
        $errors.Add("$prefix : tags must contain at least one item")
    } else {
        foreach ($tag in $tags) {
            if ($null -eq $tag -or [string]::IsNullOrWhiteSpace([string]$tag)) {
                $errors.Add("$prefix : tags must not contain empty values")
                break
            }
        }
    }

    $stars = $entry.stars
    if ($null -ne $stars -and $stars -isnot [int] -and $stars -isnot [long]) {
        $errors.Add("$prefix : stars must be a number or null")
    }

    $status = [string]$entry.status
    if (-not [string]::IsNullOrWhiteSpace($status) -and -not $validStatusSet.Contains($status)) {
        $errors.Add("$prefix : invalid status '$status'")
    }

    $entryKind = [string]$entry.entry_kind
    if (-not [string]::IsNullOrWhiteSpace($entryKind) -and -not $validEntryKindSet.Contains($entryKind)) {
        $errors.Add("$prefix : invalid entry_kind '$entryKind'")
    }

    if ($entry.featured -isnot [bool]) {
        $errors.Add("$prefix : featured must be true or false")
    }
}

foreach ($kv in $urlToIndices.GetEnumerator()) {
    if ($kv.Value.Count -gt 1) {
        $idx = ($kv.Value -join ', ')
        $errors.Add("Duplicate repo_url '$($kv.Key)' at entries: $idx")
    }
}

foreach ($kv in $nameToIndices.GetEnumerator()) {
    if ($kv.Value.Count -gt 1) {
        $idx = ($kv.Value -join ', ')
        $errors.Add("Duplicate name '$($kv.Key)' at entries: $idx")
    }
}

if ($errors.Count -gt 0) {
    foreach ($message in $errors) {
        Write-Host $message -ForegroundColor Red
    }
    exit 1
}

$plural = if ($entries.Count -eq 1) { 'y' } else { 'ies' }
Write-Host ("skills.json is valid: {0} entr{1}." -f $entries.Count, $plural) -ForegroundColor Green
exit 0
