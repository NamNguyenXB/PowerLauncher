<#
.SYNOPSIS
Start a Power Module.

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Start-Module {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config
  )

  try {
    if (Confirm-ModuleRun -Module $Module) {

      Write-ModuleHead -Module $Module
  
      $ModuleFunction = Get-ModuleFunction -Module $Module
      &"$ModuleFunction" $Module $Config
  
      Write-ModuleTail -Module $Module
    }
  }
  catch {
    Write-ModuleError -Module $Module -Config $Config -ModuleError $_
  }
}