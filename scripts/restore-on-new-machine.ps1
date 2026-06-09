[CmdletBinding()]
param(
    [string]$VaultPath = 'D:\software\AI-Workspace\lqtedu-web-ai'
)

$ErrorActionPreference = 'Continue'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host 'AI workflow restore helper'
Write-Host 'This script does not handle API keys, tokens, cookies, passwords, or Git credentials.'
Write-Host ''

[Environment]::SetEnvironmentVariable('OBSIDIAN_VAULT_PATH', $VaultPath, 'User')
$env:OBSIDIAN_VAULT_PATH = $VaultPath
Write-Host "Set user OBSIDIAN_VAULT_PATH=$VaultPath"

$dirs = @(
    (Join-Path $env:USERPROFILE '.codex'),
    (Join-Path $env:USERPROFILE '.codex\skills'),
    (Join-Path $env:USERPROFILE '.codex\log')
)
foreach ($d in $dirs) {
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Force -Path $d | Out-Null
        Write-Host "Created runtime directory: $d"
    } else {
        Write-Host "Runtime directory exists: $d"
    }
}

$codexFound = $false
try {
    $cmd = Get-Command codex -ErrorAction SilentlyContinue
    if ($cmd) { $codexFound = $true; Write-Host "Codex command found: $($cmd.Source)" }
} catch {}
if (-not $codexFound) {
    Write-Host 'Codex command was not found in PATH. Install Codex/Codex Desktop and log in manually.' -ForegroundColor Yellow
}

$hermesLocal = Join-Path $env:LOCALAPPDATA 'hermes'
$hermesUser = Join-Path $env:USERPROFILE '.hermes'
foreach ($p in @($hermesLocal, $hermesUser)) {
    if (Test-Path -LiteralPath $p) {
        $item = Get-Item -Force -LiteralPath $p
        Write-Host "Hermes path exists: $p [$($item.Attributes)] $($item.LinkType) $($item.Target)"
    } else {
        Write-Host "Hermes path missing: $p. Install Hermes and configure DS V4 manually; create D-drive Junction if needed." -ForegroundColor Yellow
    }
}

Write-Host ''
Write-Host 'Manual steps still required:'
Write-Host '1. Log in to Codex manually.'
Write-Host '2. Configure Hermes DS V4 API manually; do not write API keys into repo files.'
Write-Host '3. Re-clone company repo into the Vault repo directory if missing.'
Write-Host '4. Sync skills from D:\software\Amadeus-AI-SKILL-QA-FILE\SKILL to %USERPROFILE%\.codex\skills after confirmation.'
Write-Host ''

$health = 'D:\software\Amadeus-AI-SKILL-QA-FILE\scripts\check-ai-workflow-health.ps1'
if (Test-Path -LiteralPath $health) {
    & $health
} else {
    Write-Host "Health check script not found: $health" -ForegroundColor Yellow
}
