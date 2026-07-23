$CurrentDir = $PSScriptRoot

Invoke-Expression (&starship init powershell)
oh-my-posh init pwsh --config "$CurrentDir\myposhconfig.json" | Invoke-Expression

Import-Module PSReadLine # Better history & completion
Set-PSReadLineOption -PredictionSource History

# Source other settings
Get-ChildItem "$CurrentDir\lib\*.ps1" | ForEach-Object { . $_.FullName }

# Source local settings
$localProfile = "$HOME\local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
