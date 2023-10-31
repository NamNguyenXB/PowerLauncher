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
function Start-Launcher {
  param (
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $ConfigurationPath = $null,

    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $SetupPath = $null,
    
    [ValidateScript({ Test-Path $_ })]
    $ModulesPath
  )

  # Load Config
  if ($null -ne $ConfigurationPath) {
    $Config = Get-Content $ConfigurationPath | ConvertFrom-Json
  }
  else {
    $Config = @{}
  }

  # Load Setup Modules
  if ($null -ne $SetupPath) {
    $SetupModules = Get-Content $SetupPath | ConvertFrom-Json
  }

  # Load Modules
  $Modules = Get-Content $ModulesPath | ConvertFrom-Json

  # Add the InstallFolder to the $Config
  if (-not $Config.InstallFolder) {
    $InstallFolder = $env:PowerLauncher_InstallDir
    $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
  }

  # Start Setup Heads
  Start-Modules -Modules $SetupModules -Config $Config -IsSetup -Head

  # Start Modules
  Start-Modules -Modules $Modules -Config $Config

  # Start Setup Tails
  Start-Modules -Modules $SetupModules -Config $Config -IsSetup

  if (-not $Config.CloseWhenDone) {
    Read-Host -Prompt "Press Enter to exit"
  }
}