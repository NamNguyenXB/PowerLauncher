<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-SetupLauncher {
  param(
    [Alias("s", "l")]
    $SetupLauncher,
    [Alias("c")]
    $Config,
    [Alias("h")]
    [bool] $Head = $true
  )
  if ($SetupLauncher.Run) {
    IF( $true -eq $Head){
      $Launcher = $SetupLauncher.LauncherHead
    } ELSE {
      $Launcher = $SetupLauncher.LauncherTail
    }
    
    Invoke-Launcher $Launcher $Config
  }
}