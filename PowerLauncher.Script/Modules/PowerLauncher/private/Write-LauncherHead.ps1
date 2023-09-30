<#
.SYNOPSIS
Write information (Head) of a launcher.

.PARAMETER Launcher
Launcher to display.

.EXAMPLE
Write-LauncherHead -Launcher $Launcher
#>
function Write-LauncherHead {
  param (
    [Alias("l")]
    [Parameter(HelpMessage = "Launcher to display.")]
    $Launcher
  )

  Write-Box -Content $Launcher.Name -Tag "Begin"
  Write-Line
  Write-Content "|  Launch Options:"
  $Launcher.PSObject.Properties | ForEach-Object {
    if (($_.Name) -ne "Name") {
      Write-Content "|  - $(${_}.Name): $(${_}.Value)"
    }
  }
}