Invoke-Expression (&starship init powershell)
oh-my-posh init pwsh --config ~/myposhconfig.json | Invoke-Expression

function Clean-Path {
  $seen = @{}
  $newPaths = @()
    foreach ($p in $env:PATH -split ";") {
      $normalized = $p.Trim().ToLower()
      if ($normalized -ne "" -and -not $seen.ContainsKey($normalized)) {
        $seen[$normalized] = $true
        $newPaths += $p.Trim()
      }
    }
  $env:PATH = $newPaths -join ";"
}

Import-Module PSReadLine # Better history & completion
Set-PSReadLineOption -PredictionSource History

Clean-Path # Remove duplicate paths from PATH environment variable

$env:PATH += ";..." # Add new path to PATH environment variable
