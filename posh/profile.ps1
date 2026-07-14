Invoke-Expression (&starship init powershell)
oh-my-posh init pwsh --config "$PoshDir\myposhconfig.json" | Invoke-Expression

Import-Module PSReadLine # Better history & completion
Set-PSReadLineOption -PredictionSource History

# Source other settings
. "$PoshDir\lib\path.ps1"

# Source local settings
$localProfile = "$HOME\local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
