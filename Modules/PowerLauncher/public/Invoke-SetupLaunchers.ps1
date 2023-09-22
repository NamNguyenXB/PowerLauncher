<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-SetupLaunchers {
  param(
    [Alias("s", "l")]
    $SetupLaunchers,
    [Alias("c")]
    $Config,
    [Alias("h")]
    [bool] $Head = $true
  )
  $SetupLaunchers | ForEach-Object {
    $SetupLauncher = $_
    if ($SetupLauncher.Run) {
      IF( $true -eq $Head){
        $Launcher = $SetupLauncher.LauncherHead
      } ELSE {
        $Launcher = $SetupLauncher.LauncherTail
      }
      Invoke-Launcher $Launcher $Config
    }
  }
}