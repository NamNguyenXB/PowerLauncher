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

    # Start Setup Heads
    $SetupModules | ForEach-Object {
      $Module = $_
      Start-SetupModule -Module $Module -Config $Config
    }

    # Start Modules
    $Modules | ForEach-Object {
      $Module = $_
      Start-Module -Module $Module -Config $Config
    }

    # Start Setup Tails
    $SetupModules | ForEach-Object {
      $Module = $_
      Start-SetupModule -Module $Module -Config $Config -Tail
    }

    if (-not $Config.CloseWhenDone) {
      Read-Host -Prompt "Press Enter to exit"
    }
  }
  catch {
    Write-LauncherError -LauncherError $_
  }
}