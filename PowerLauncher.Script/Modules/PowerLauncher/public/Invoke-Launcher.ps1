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
  if (($null -eq $Launcher) -or (-not $Launcher.Run)) {
    return;
  }

  Write-ModuleHead -l $Launcher

  $Type = $Launcher.Type
  $FunctionName = "Invoke-" + $Type

  if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    Install-LauncherType -t $Type -d $Config.InstallFolder + "\launchers"
  }

  if ($null -ne (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    &"$FunctionName" $Launcher $Config
  }
  else {
    Write-Content "|  Cannot run! Type $Type is not supported."
  }

  Write-ModuleTail -l $Launcher
}