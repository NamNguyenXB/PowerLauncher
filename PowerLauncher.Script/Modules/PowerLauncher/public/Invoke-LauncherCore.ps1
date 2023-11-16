<#
.SYNOPSIS
Run a launcher.

.DESCRIPTION
Run a launcher which contains many modules.

.PARAMETER Launcher
Launcher that will be run.

.EXAMPLE

#>
function Invoke-LauncherCore {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNull()]
    $Launcher
  )

  begin {}

  process {
    try {

      # Initialize variables
      $Config = $Launcher.Config
      $SetupModules = $Launcher.SetupModules
      $Modules = $Launcher.Modules
      $IsRunValid = $true
      $global:ModuleErrors = @{}

      # Get SkipErrors Config.
      if ($true -ne $Config.SkipErrors) {
        $SkipErrors = $false;
      }
      else {
        $SkipErrors = $true;
      }

      # Start Setup Heads
      if ($IsRunValid) {
        foreach ($Module in $SetupModules) {
          Invoke-SetupModule -Module $Module -Config $Config
  
          # Stop if error.
          if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
            $IsRunValid = $false;
            break;
          }
        }
      }

      # Start Modules
      if ($IsRunValid) {
        foreach ($Module in $Modules) {
          Invoke-Module -Module $Module -Config $Config

          # Stop if error.
          if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
            $IsRunValid = $false;
            break
          }
        }
      }

      # Start Setup Tails
      if ($IsRunValid) {
        foreach ($Module in $SetupModules) {
          Invoke-SetupModule -Module $Module -Config $Config -Tail

          # Stop if error.
          if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
            $IsRunValid = $false;
            break
          }
        }
      }

      Write-ModuleErrors -ModuleErrors $ModuleErrors

      if (-not $Config.CloseWhenDone) {
        Read-Host -Prompt "Press Enter to exit"
      }
    }
    catch {
      Write-LauncherError -LauncherError $_
    }
  }

  end {}
}