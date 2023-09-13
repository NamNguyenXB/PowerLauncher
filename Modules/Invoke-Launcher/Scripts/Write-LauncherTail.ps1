if ($null -eq (Get-Command Write-LauncherTail -EA SilentlyContinue)) {
  function Write-LauncherTail {
    param (
      $Launcher
    )

    Write-End $Launcher.Name
  }
}