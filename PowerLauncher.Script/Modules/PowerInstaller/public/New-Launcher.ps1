<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER ConfigurationPath
Path of the configuration file.

.PARAMETER SetupPath
Path of the Launcher information file.

.PARAMETER ModulesPath
Path of the Launcher information file.

.EXAMPLE

#>
function New-Launcher {
  param (
    $LauncherName,
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $ConfigurationPath = $null,
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $SetupPath = $null,
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    $ModulesPath = $null
  )

  if (($null -eq $LauncherName) -or ("" -eq $LauncherName)) {
    $LauncherName = Read-Host "New launcher name"
    if (($null -eq $LauncherName) -or ("" -eq $LauncherName)) {
      throw "Launcher name must not be null or empty."
    }
  }

  $SoftwareDirectory = $env:PowerLauncher_InstallDir

  # Create a new directory for the new Launcher.
  $LauncherDirectory = "$SoftwareDirectory\Launchers\$LauncherName"
  if (-not(Test-Path $LauncherDirectory)) {
    New-Item -ItemType Directory -Path $LauncherDirectory
  }

  if (($null -eq $ConfigurationPath)) {
    $ConfigurationPath = "$SoftwareDirectory\configuration.json"
  }

  if ($null -eq $SetupPath) {
    Copy-Item "$TemplatesDirectory\setup.json" -Destination "$LauncherDirectory" -ErrorAction SilentlyContinue
    $SetupPath = "$LauncherDirectory\setup.json"
  }

  if ($null -eq $ModulesPath) {
    Write-Output "[]" > "$LauncherDirectory\modules.json"
    $ModulesPath = "$LauncherDirectory\modules.json"
  }

  # Get destination file path
  $Params = ""
  $Params += " -ConfigurationPath $ConfigurationPath"
  $Params += " -SetupPath $SetupPath"
  $Params += " -ModulesPath $ModulesPath"

  # Create a new shortcut file
  Write-Verbose "Create new shortcut"
  Write-Output "Import-Module PowerLauncher;Start-Launcher $Params" > "$LauncherDirectory\$LauncherName.ps1"
  New-Shortcut -f "$LauncherDirectory\$LauncherName.ps1" -RunAsAdministrator
}