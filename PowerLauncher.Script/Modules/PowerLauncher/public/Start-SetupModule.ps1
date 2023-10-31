<#
.SYNOPSIS
Start a Power Module.

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Start-SetupModule {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config,

    [Switch]$Tail
  )

  if (Confirm-ModuleRun -Module $Module) {

    if ($Tail.IsPresent) {
      Start-Module -Module $Module.Tail -Config $Config
    }
    else {
      Start-Module -Module $Module.Head -Config $Config
    }
  }
}