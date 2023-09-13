if ($null -eq (Get-Command Write-LauncherHead -EA SilentlyContinue)) {
  function Write-LauncherHead {
    param (
      $Launcher
    )

    Write-Begin $Launcher.Name
    Write-Output "|  Launch Options:"
    $Launcher.PSObject.Properties | ForEach-Object {
      if (($_.Name) -ne "Name") {
        Write-Output "|  - $(${_}.Name): $(${_}.Value)"
      }
    }
  }
}