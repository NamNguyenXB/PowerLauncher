<#
.SYNOPSIS
Run a launcher.

.DESCRIPTION
Run a launcher which contains many modules.

.PARAMETER ConfigurationPath
Path of the configuration file.

.PARAMETER SetupPath
Path of the Launcher setup file.

.PARAMETER ModulesPath
Path of the Launcher information file.

.EXAMPLE

#>
function Invoke-LauncherCore {
  param (
    $Launcher
  )

  try {
    if ($null -ne $Launcher) {
      # Load Config
      $Config = $Launcher.Config
      if($null -eq $Config){
        $Config = @{}
      }

      # Load Setup Modules
      $SetupModules = $Launcher.SetupModules
      if($null -eq $SetupModules){
        $SetupModules = @()
      }

      # Load Modules
      $Modules = $Launcher.Modules
      if($null -eq $Modules){
        $Modules = @()
      }

      # Initialize Module Errors.
      $global:ModuleErrors = @{}

      # Get SkipErrors Config.
      if ($true -ne $Config.SkipErrors) {
        $SkipErrors = $false;
      }else{
        $SkipErrors = $true;
      }

      # Initialize RunValidFlag
      $IsRunValid = $true

      # Start Setup Heads
      if ($IsRunValid) {
        foreach ($Module in $SetupModules) {
          Invoke-SetupModule -Module $Module -Config $Config
  
          if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
            $IsRunValid = $false;
            break
          }
        }
      }

      # Start Modules
      if ($IsRunValid) {
        foreach ($Module in $Modules) {
          Invoke-Module -Module $Module -Config $Config

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
  }
  catch {
    Write-LauncherError -LauncherError $_
  }
}