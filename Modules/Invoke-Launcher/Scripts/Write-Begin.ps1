if ($null -eq (Get-Command Write-Begin -EA SilentlyContinue)) {
  function Write-Begin ($Content) {
    if ($Content.Length -lt 1) {
      Write-Header "BEGIN"
    }
    else {
      Write-Header "$Content | BEGIN"
    }
    Write-Line
  }
}