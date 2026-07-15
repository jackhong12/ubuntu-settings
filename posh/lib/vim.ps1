function vime {
  if (git status 2>$null) {
    $files = git status --short | Where-Object { $_ -match '^ M' } | ForEach-Object { $_.Substring(3).Trim() }
  } else {
    $root = (p4 client -o 2>$null | Select-String '^Root:' | ForEach-Object { $_ -replace '^Root:\s+', '' })
    $files = p4 opened 2>$null | ForEach-Object {
      if ($_ -match '//[^/]+/[^/]+/(?:rel|dev)/([^#]+)#') {
        Join-Path $root $Matches[1]
      }
    }
  }

  if ($files) {
    Write-Host "`e[0;32m$ vim $files`e[0m"
    & vim @files
  }
}
