<#
.SYNOPSIS
Start a Power Module.

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-Module {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config
  )

  try {
    # Validate Module before running
    if (Confirm-ModuleRun -Module $Module) {
      # Write Module Head
      Write-ModuleHead -Module $Module

      # Run Module
      Invoke-ModuleFunction -Module $Module -Config $Config

      # Write Module Tail.
      Write-ModuleTail -Module $Module
    }
  }
  catch {
    Write-ModuleError -Module $Module -Config $Config -ModuleError $_
  }
}