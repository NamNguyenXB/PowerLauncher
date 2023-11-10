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
      try {
        Invoke-ModuleFunction -Module $Module -Config $Config
      }
      catch {
        Write-ModuleError -Module $Module -Config $Config -ModuleError $_
      }

      # Write Module Tail.
      Write-ModuleTail -Module $Module
    }
  }
  catch {
    Write-ModuleError -Module $Module -Config $Config -ModuleError $_
  }
}