[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Test-PathInfo {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [string]$Role = '',
        [switch]$ExpectDirectory,
        [switch]$ExpectFile,
        [switch]$ExpectGit
    )
    $exists = Test-Path -LiteralPath $Path
    $item = if ($exists) { Get-Item -Force -LiteralPath $Path } else { $null }
    $isDir = if ($item) { [bool]$item.PSIsContainer } else { $false }
    $status = 'OK'
    $detail = ''
    if (-not $exists) { $status = 'MISSING' }
    elseif ($ExpectDirectory -and -not $isDir) { $status = 'WARN'; $detail = 'expected directory' }
    elseif ($ExpectFile -and $isDir) { $status = 'WARN'; $detail = 'expected file' }
    elseif ($ExpectGit -and -not (Test-Path -LiteralPath (Join-Path $Path '.git'))) { $status = 'WARN'; $detail = 'missing .git' }
    [pscustomobject]@{
        Check = $Role
        Path = $Path
        Status = $status
        Detail = $detail
        Attributes = if ($item) { $item.Attributes.ToString() } else { '' }
        LinkType = if ($item) { $item.LinkType } else { '' }
        Target = if ($item -and $item.Target) { ($item.Target -join '; ') } else { '' }
    }
}

$results = New-Object System.Collections.Generic.List[object]

$c = Get-PSDrive C
$freeGB = [math]::Round($c.Free / 1GB, 2)
$results.Add([pscustomobject]@{
    Check='C drive free space'
    Path='C:\'
    Status= if ($c.Free -lt 2GB) { 'WARN' } else { 'OK' }
    Detail="Free ${freeGB} GB"
    Attributes=''
    LinkType=''
    Target=''
})

$hermesLocal = Join-Path $env:LOCALAPPDATA 'hermes'
$hermesUser = Join-Path $env:USERPROFILE '.hermes'
foreach ($p in @($hermesLocal, $hermesUser)) {
    $row = Test-PathInfo -Path $p -Role 'Hermes Junction' -ExpectDirectory
    if ($row.Status -eq 'OK') {
        if ($row.LinkType -ne 'Junction') {
            $row.Status = 'WARN'
            $row.Detail = 'not a Junction; may occupy C drive'
        } elseif ($row.Target -notlike 'D:\*') {
            $row.Status = 'WARN'
            $row.Detail = 'Junction target is not D drive'
        } else {
            $row.Detail = 'Junction target on D drive'
        }
    }
    $results.Add($row)
}

$paths = @(
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md'; Role='formal md source'; Dir=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\communications'; Role='communications'; Dir=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL'; Role='generated SKILL'; Dir=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\scripts'; Role='scripts'; Dir=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\runtime'; Role='runtime profiles'; Dir=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-knowledge-source-policy.md'; Role='knowledge source policy'; File=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-agent-entry-index.md'; Role='agent entry index'; File=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-migration-and-restore-guide.md'; Role='migration guide'; File=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-runtime-sync-policy.md'; Role='runtime sync policy'; File=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-ai-workflow-runbook.md'; Role='workflow runbook'; File=$true},
    @{Path='D:\software\Amadeus-AI-SKILL-QA-FILE\md\00-folder-purpose-map.md'; Role='folder purpose map'; File=$true},
    @{Path='D:\software\AI-Workspace\lqtedu-web-ai'; Role='Obsidian Vault'; Dir=$true},
    @{Path='D:\software\AI-Workspace\lqtedu-web-ai\_ai\hermes'; Role='Hermes workspace'; Dir=$true},
    @{Path='D:\software\AI-Workspace\lqtedu-web-ai\repo'; Role='company repo'; Dir=$true; Git=$true},
    @{Path=(Join-Path $env:USERPROFILE '.codex\skills'); Role='Codex runtime skills'; Dir=$true},
    @{Path=(Join-Path $env:USERPROFILE '.codex\sessions'); Role='Codex sessions, read only'; Dir=$true},
    @{Path=(Join-Path $env:USERPROFILE '.codex\log'); Role='Codex log'; Dir=$true}
)
foreach ($p in $paths) {
    $results.Add((Test-PathInfo -Path $p.Path -Role $p.Role -ExpectDirectory:([bool]$p.Dir) -ExpectFile:([bool]$p.File) -ExpectGit:([bool]$p.Git)))
}

$vaultExpected = 'D:\software\AI-Workspace\lqtedu-web-ai'
$results.Add([pscustomobject]@{
    Check='OBSIDIAN_VAULT_PATH'
    Path='env:OBSIDIAN_VAULT_PATH'
    Status= if ($env:OBSIDIAN_VAULT_PATH -eq $vaultExpected) { 'OK' } else { 'WARN' }
    Detail="Current=$env:OBSIDIAN_VAULT_PATH; Expected=$vaultExpected"
    Attributes=''
    LinkType=''
    Target=''
})

$repoSkill = 'D:\software\AI-Workspace\lqtedu-web-ai\.codex\skills'
if (Test-Path -LiteralPath $repoSkill) {
    $results.Add([pscustomobject]@{
        Check='Repository .codex skills risk'
        Path=$repoSkill
        Status='WARN'
        Detail='repo .codex\skills exists; avoid maintaining two runtime skill layers'
        Attributes=(Get-Item -LiteralPath $repoSkill).Attributes.ToString()
        LinkType=''
        Target=''
    })
}

$results | Format-Table -AutoSize

if ($results.Status -contains 'MISSING') { exit 2 }
if ($results.Status -contains 'WARN') { exit 1 }
exit 0
