<#
.SYNOPSIS
Start a launcher.

.PARAMETER ConfigurationPath
Path of the configuration file.

.PARAMETER SetupPath
Path of the Launcher setup file.

.PARAMETER ModulesPath
Path of the Launcher information file.

.EXAMPLE

#>
function Invoke-Launcher {
  param (
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $ConfigurationPath = $null,

    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $SetupPath = $null,
    
    [ValidateScript({ Test-Path $_ })]
    $ModulesPath
  )

  try {
    # Initialize Log Level
    if ($null -eq $LogLevel) {
      $global:LogLevel = 0
    }

    # Load Config
    $Config = Get-ObjectFromJsonFile -Path $ConfigurationPath -DefaultValue @{}

    # Load Setup Modules
    $SetupModules = Get-ObjectFromJsonFile -Path $SetupPath -DefaultValue @()

    # Load Modules
    $Modules = Get-ObjectFromJsonFile -Path $ModulesPath -DefaultValue @()

    # Add the InstallFolder to the $Config
    if (-not $Config.InstallFolder) {
      $InstallFolder = $env:PowerLauncher_InstallDir
      $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
    }

    $SkipErrors = $Config.SkipErrors
    $global:ModuleErrors = @{}
    $RunValid = $true

    if ($true -ne $SkipErrors) {
      $SkipErrors = $false;
    }

    # Start Setup Heads
    if ($RunValid) {
      foreach ($Module in $SetupModules) {
        Invoke-SetupModule -Module $Module -Config $Config
  
        if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
          $RunValid = $false;
          break
        }
      }
    }

    # Start Modules
    if ($RunValid) {
      foreach ($Module in $Modules) {
        Invoke-Module -Module $Module -Config $Config

        if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
          $RunValid = $false;
          break
        }
      }
    }

    # Start Setup Tails
    if ($RunValid) {
      foreach ($Module in $SetupModules) {
        Invoke-SetupModule -Module $Module -Config $Config -Tail

        if ((-not $SkipErrors) -and ($ModuleErrors.Count -gt 0)) {
          $RunValid = $false;
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