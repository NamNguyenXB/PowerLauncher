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

  try {
    if (Confirm-ModuleRun -Module $Module) {

      if ($Tail.IsPresent) {
        $Module = $Module.Tail;
      }
      else {
        $Module = $Module.Head;
      }
  
      Invoke-Module -Module $Module -Config $Config
    }
  }
  catch {
    Write-ModuleError -Module $Module -Config $Config -ModuleError $_
  }
}