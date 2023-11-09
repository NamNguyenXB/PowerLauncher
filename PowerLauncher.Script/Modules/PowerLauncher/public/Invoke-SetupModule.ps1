<#
.SYNOPSIS
Start a Power Module.

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-SetupModule {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config,

    [Switch]$Tail
  )

  if (Confirm-ModuleRun -Module $Module) {

    if (-not $Tail.IsPresent) {
      $Module = $Module.Head
    }
    else {
      $Module = $Module.Tail
    }

    Invoke-Module -Module $Module -Config $Config
  }
}