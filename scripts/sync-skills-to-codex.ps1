[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [switch]$Apply,
    [switch]$Mirror,
    [switch]$ConfirmMirror
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$Source = 'D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL'
$Target = Join-Path $env:USERPROFILE '.codex\skills'

if (-not (Test-Path -LiteralPath $Source)) {
    throw "Source SKILL directory not found: $Source"
}

if ($Mirror -and -not $ConfirmMirror) {
    throw 'Mirror mode may delete target-only files. Re-run with -Mirror -ConfirmMirror after explicit human confirmation.'
}

$sourceSkills = Get-ChildItem -LiteralPath $Source -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')
}
$targetSkills = if (Test-Path -LiteralPath $Target) {
    Get-ChildItem -LiteralPath $Target -Directory | Where-Object {
        Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')
    }
} else { @() }

Write-Host "Source: $Source"
Write-Host "Target: $Target"
Write-Host "Mode:   $(if ($Apply) { 'APPLY' } else { 'DRY-RUN' })"
Write-Host ''

$plan = foreach ($skill in $sourceSkills) {
    $targetDir = Join-Path $Target $skill.Name
    $srcHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $skill.FullName 'SKILL.md')).Hash
    $dstHash = if (Test-Path -LiteralPath (Join-Path $targetDir 'SKILL.md')) {
        (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $targetDir 'SKILL.md')).Hash
    } else { $null }
    [pscustomobject]@{
        Skill = $skill.Name
        Action = if (-not (Test-Path -LiteralPath $targetDir)) { 'Create' } elseif ($srcHash -ne $dstHash) { 'Update' } else { 'NoChange' }
        SourceHash = $srcHash.Substring(0,12)
        TargetHash = if ($dstHash) { $dstHash.Substring(0,12) } else { '' }
        Target = $targetDir
    }
}
$plan | Format-Table -AutoSize

if ($Mirror) {
    $sourceNames = @($sourceSkills | ForEach-Object { $_.Name })
    $unknown = $targetSkills | Where-Object { $sourceNames -notcontains $_.Name }
    if ($unknown) {
        Write-Host ''
        Write-Host 'Mirror target-only skills planned for removal:' -ForegroundColor Yellow
        $unknown | Select-Object Name,FullName | Format-Table -AutoSize
    }
}

if (-not $Apply) {
    Write-Host ''
    Write-Host 'Dry-run only. Re-run with -Apply to copy. Mirror deletion requires -Mirror -ConfirmMirror.'
    exit 0
}

New-Item -ItemType Directory -Force -Path $Target | Out-Null
foreach ($skill in $sourceSkills) {
    $targetDir = Join-Path $Target $skill.Name
    Copy-Item -LiteralPath $skill.FullName -Destination $Target -Recurse -Force
    Write-Host "Synced: $($skill.Name) -> $targetDir"
}

if ($Mirror) {
    $sourceNames = @($sourceSkills | ForEach-Object { $_.Name })
    $unknown = $targetSkills | Where-Object { $sourceNames -notcontains $_.Name }
    foreach ($u in $unknown) {
        Remove-Item -LiteralPath $u.FullName -Recurse -Force
        Write-Host "Removed target-only skill: $($u.Name)" -ForegroundColor Yellow
    }
}

Write-Host 'Done.'
