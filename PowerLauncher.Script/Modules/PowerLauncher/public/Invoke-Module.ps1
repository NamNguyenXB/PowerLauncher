<#
.SYNOPSIS
Invoke a Power Module.

.DESCRIPTION
Invoke a Power Module.

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Invoke-Module {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    $Module,

    [Parameter()]
    [ValidateNotNull()]
    $Config = @{},

    [Parameter()]
    $Logger
  )

  begin {}

  process {
    # Stop processing if the module is disabled.
    if ($true -ne $Module.Run) {
      return;
    }

    try {
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
    catch {
      Write-ModuleError -Module $Module -Config $Config -ModuleError $_
    }
  }

  end {}
}