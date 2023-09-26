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
  IF (($null -ne $Launchers) -and ($Launchers.Length -lt 0)) {
    $Launchers | ForEach-Object {
      $Launcher = $_
      Invoke-Launcher $Launcher $Config
    }
  }
}