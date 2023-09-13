if ($null -eq (Get-Command Write-Line -EA SilentlyContinue)) {
  function Write-Line {
    $Dashx120 = "----------------------------------------------------------------------------------------------------"
    Write-Output $Dashx120
  }

}