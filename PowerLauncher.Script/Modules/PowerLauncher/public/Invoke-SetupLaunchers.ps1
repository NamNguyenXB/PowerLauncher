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
    [switch] $Head
  )
  IF (($null -ne $SetupLaunchers) -and ($SetupLaunchers.Length -gt 0)) {
    $SetupLaunchers | ForEach-Object {
      $SetupLauncher = $_
      if ($SetupLauncher.Run) {
        IF ( $Head.IsPresent) {
          $Launcher = $SetupLauncher.LauncherHead
        }
        ELSE {
          $Launcher = $SetupLauncher.LauncherTail
        }
        Invoke-Launcher $Launcher $Config
      }
    }
  }
}