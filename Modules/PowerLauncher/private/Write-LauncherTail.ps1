<#
.SYNOPSIS
Write information (Tail) of a launcher.

.PARAMETER Launcher
Launcher to display.

.EXAMPLE
Write-LauncherTail -Launcher $Launcher
#>
function Write-LauncherTail {
  param (
    [Alias("l")]
    [Parameter(HelpMessage = "Launcher to display.")]
    [ValidateNotNull]
    $Launcher
  )
  Write-Line
  Write-Box -c $Launcher.Name -t "End  "
}