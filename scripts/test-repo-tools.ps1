#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$workDir = Join-Path $env:TEMP ("persona-skill-tests-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $workDir | Out-Null

try {
    $validDataPath = Join-Path $workDir 'valid-skills.json'
    $invalidDataPath = Join-Path $workDir 'invalid-skills.json'
    $readmePath = Join-Path $workDir 'README.generated.md'

    @'
[
  {
    "name": "测试老板.skill",
    "category": "职场角色人格 Skill",
    "type": "角色人格 Skill",
    "description": "从老板视角挑方案问题，适合工作复盘。",
    "repo_url": "https://github.com/example/test-boss-skill",
    "tags": ["角色", "职场"],
    "stars": 12,
    "status": "active",
    "entry_kind": "skill",
    "featured": true
  },
  {
    "name": "测试镜像人格",
    "category": "经典人格 / 自我镜像 Skill",
    "type": "人格化 AI Repo",
    "description": "用数字分身视角复盘自己，适合做自我镜像对话。",
    "repo_url": "https://github.com/example/test-self-repo",
    "tags": ["人格", "镜像"],
    "stars": null,
    "status": "watchlist",
    "entry_kind": "persona_repo",
    "featured": false
  }
]
'@ | Set-Content -LiteralPath $validDataPath -Encoding UTF8

    @'
[
  {
    "name": "坏数据",
    "category": "职场角色人格 Skill",
    "type": "角色人格 Skill",
    "description": "缺少有效标签和条目类型。",
    "repo_url": "not-a-url",
    "tags": [],
    "stars": "oops",
    "status": "broken",
    "entry_kind": "unknown",
    "featured": "yes"
  }
]
'@ | Set-Content -LiteralPath $invalidDataPath -Encoding UTF8

    Write-Host 'Running validator against valid fixture...'
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\validate-skills.ps1') -DataPath $validDataPath
    if ($LASTEXITCODE -ne 0) {
        throw 'Validator should accept the valid fixture.'
    }

    Write-Host 'Running validator against invalid fixture...'
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\validate-skills.ps1') -DataPath $invalidDataPath
    if ($LASTEXITCODE -eq 0) {
        throw 'Validator should reject the invalid fixture.'
    }

    Write-Host 'Generating README from valid fixture...'
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\generate-readme.ps1') -DataPath $validDataPath -ReadmePath $readmePath
    if ($LASTEXITCODE -ne 0) {
        throw 'README generator should succeed on the valid fixture.'
    }

    $generated = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
    if ($generated -notmatch '测试老板\.skill') {
        throw 'Generated README is missing the featured entry.'
    }
    if ($generated -notmatch '## 职场角色人格 Skill') {
        throw 'Generated README is missing the category heading.'
    }
    if ($generated -notmatch '\| 项目 \| 类型 \| 标签 \| Stars \| 一句话说明 \|') {
        throw 'Generated README is missing the category table header.'
    }
    if ($generated -notmatch '\| \[测试老板\.skill\]\(https://github\.com/example/test-boss-skill\) \| 标准Skill \|') {
        throw 'Generated README is missing the category table row.'
    }
    if ($generated -notmatch '(?m)^- \[测试老板\.skill\]\(https://github\.com/example/test-boss-skill\)') {
        throw 'Generated README is missing the featured list item.'
    }
    if ($generated -notmatch '标签：`角色` `职场` \| Stars：12') {
        throw 'Generated README should keep featured entries in list format.'
    }

    Write-Host 'All repository tool tests passed.' -ForegroundColor Green
    exit 0
}
finally {
    if (Test-Path -LiteralPath $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force
    }
}
