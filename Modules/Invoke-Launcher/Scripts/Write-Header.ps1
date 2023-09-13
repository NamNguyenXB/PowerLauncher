if ($null -eq (Get-Command Write-Header -EA SilentlyContinue)) {
  function Write-Header( $Content) {
    $ContentLength = $Content.Length
    $Dashes = "o" + "-" * ($ContentLength + 2) + "o"
    Write-Output $Dashes
    Write-Output "| $Content |"
    Write-Output $Dashes
  }
}