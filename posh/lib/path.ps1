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

Clean-Path # Remove duplicate paths from PATH environment variable

#$env:PATH += ";..." # Add new path to PATH environment variable
$env:PATH += ";C:\Program Files\Vim\vim92\" # Add new path to PATH environment variable
