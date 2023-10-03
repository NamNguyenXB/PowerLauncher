if ($null -eq (Get-Command Invoke-Test -EA SilentlyContinue)) {
  function Invoke-Test {
    param($Launcher, $Config)

    if ($Launcher.Run) {
      Write-Output Hello
    }
  }
}