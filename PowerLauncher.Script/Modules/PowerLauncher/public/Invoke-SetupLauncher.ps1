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
    [switch] $Head
  )
  if ($SetupLauncher.Run) {
    IF ($Head.IsPresent) {
      $Launcher = $SetupLauncher.LauncherHead
    }
    ELSE {
      $Launcher = $SetupLauncher.LauncherTail
    }
    
    Invoke-Launcher $Launcher $Config
  }
}