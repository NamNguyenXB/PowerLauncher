<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Start-Module {
  param(
    $Module,
    $Config
  )
  if (Confirm-ModuleRun -Module $Module) {
    Write-ModuleHead -l $Module

    $ModuleFunction = Get-ModuleFunction -Module $Module

    &"$ModuleFunction" $Module $Config

    Write-ModuleTail -l $Module
  }
}