<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER Scope
Install Scope.

.PARAMETER InstallDir
Install Directory (Optional)

.EXAMPLE

#>

#requires -RunAsAdministrator

param (
  [Alias("sc")]
  [ValidateSet("User", "Machine")]
  [Parameter(HelpMessage = "Specify the install scope. User or Machine.")]
  $Scope = "User",
  [Alias("d", "dir", "dest")]
  [Parameter(HelpMessage = "Specify the install directory. Must be an valid folder path.")]
  [ValidateScript({ Test-Path $_ })]
  $InstallDirectory,
  [Alias("s", "source")]
  [Parameter(HelpMessage = "Specify the source directory. Must be an valid folder path.")]
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $SourceDirectory
)

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Get Source Dỉrectory
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$ThisScriptDir\.."
}
Write-Output "Source: $SourceDirectory"

# Get Install Directory
IF( $null -eq $InstallDirectory){
  $InstallDirectory = Read-Host "Please input the install-to directory:"
  If(-not (Test-Path $InstallDirectory)){
    throw "Invalid directory. Stop."
  }
}
Write-Output "Install to: $InstallDirectory"

# Get Modules directory.
$ModuleDir = "$SourceDirectory\Modules"
Write-Output "Modules directory: $ModuleDir"

# Check Modules
IF (-not (Test-Path $ModuleDir)) {
  throw "`$ModuleDir($ModuleDir) is not a folder"
}
IF (-not(Test-Path "$ModuleDir\PowerLogger")) {
  throw "Module PowerLogger was not found."
}
IF (-not(Test-Path "$ModuleDir\PowerLauncher")) {
  throw "Module PowerLauncher was not found."
}
IF (-not(Test-Path "$ModuleDir\PowerInstaller")) {
  throw "Module PowerLauncher was not found."
}

$ModulePaths = $env:PSModulePath -split ';'
IF ( $ModulePaths.Length -lt 1) {
  throw "`$env:PSModulePath is empty."
}

$ModulePath = $ModulePaths[0]
IF (-not (Test-Path $ModulePath)) {
  throw "`$ModulePath($ModulePath) is not a folder"
}

$Answer = Read-Host "Ready to Install. Continue[Y/N]? (Defaults to Y)"
IF($Answer -eq 'N'){
  return;
}

Write-Output "Import Module PowerInstaller"
Import-Module "$ModuleDir\PowerInstaller"

IF ($InstallDirectory -ne $SourceDirectory) {
  Copy-Item "$SourceDirectory\Source\*" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  Copy-Item "$SourceDirectory\Source" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  Copy-Item "$SourceDirectory\Tools" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
}

# Set environment variables
Write-Output "Set `$env:PowerLauncher_InstallDir=$InstallDirectory"
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)
Write-Output "Set `$env:PowerLauncher_ModulesDir=$ModulePath"
[Environment]::SetEnvironmentVariable('PowerLauncher_ModulesDir', $ModulePath, $Scope)


# Installl Modules
Write-Output "Modules are installed to: $ModulePath"
Write-Output "Install PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Install PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Install PowerInstaller"
Copy-Item "$ModuleDir\PowerInstaller" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Create shortcut Run.lnk"
New-Shortcut -f "$InstallDirectory\Main.ps1" -n "Run.lnk" -a

Write-Output "Create shortcut Update.lnk"
New-Shortcut -f "$InstallDirectory\Tools\UpdateModules.ps1" -d $InstallDirectory -n "Update.lnk" -a -p $SourceDirectory

Write-Output "Create shortcut New-Submodule.lnk"
New-Shortcut -f "$InstallDirectory\Tools\InstallSubModule.ps1" -d $InstallDirectory -n "New-Submodule.lnk" -a

Write-Output "Done. Software has been installed successfully."