<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-Launchers {
  param(
    [Alias("l")]
    $Launchers,
    [Alias("c")]
    $Config
  )
  $Launchers | ForEach-Object {
    $Launcher = $_
    Invoke-Launcher $Launcher $Config
  }
}