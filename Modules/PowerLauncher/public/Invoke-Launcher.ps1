<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-Launcher {
  param(
    $Launcher,
    $Config
  )
  if ($Launcher.Run) {
    Write-LauncherHead($Launcher)

    $Type = $Launcher.Type
    $FunctionName = "Invoke-" + $Type

    if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
      Install-LauncherType -t $Type -d $Config.InstallFolder + "\launchers"
    }

    if ($null -ne (Get-Command "$FunctionName" -EA SilentlyContinue)) {
      &"$FunctionName" $Launcher $Config $Verbose
    }
    else {
      Write-Output "|  Cannot run! Type $Type is not supported."
    }

    Write-LauncherTail($Launcher)
  }
}