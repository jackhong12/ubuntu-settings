$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$pathLine = "`$PoshDir = `"$PSScriptRoot`""
$sourceLine = ". `"$PSScriptRoot\profile.ps1`""
Set-Content -Path $PROFILE -Value @($pathLine, $sourceLine) -Force
Write-Host "Rewrote `$PROFILE ($PROFILE) with:`n$pathLine`n$sourceLine"
