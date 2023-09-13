if ($null -eq (Get-Command Write-End -EA SilentlyContinue)) {
  function Write-End ($Content) {
    Write-Line
    if ($Content.Length -lt 1) {
      Write-Header "End  "
    }
    else {
      Write-Header "$Content | End  "
    }
  }
}