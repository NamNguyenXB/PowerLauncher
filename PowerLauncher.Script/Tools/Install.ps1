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
  $SourceDirectory,
  [Alias("f")]
  [switch]$Force
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

# Get Install Directory
IF( $null -eq $InstallDirectory){
  $InstallDirectory = Read-Host "Please input a directory to install:"
  If(-not (Test-Path $InstallDirectory)){
    throw "Invalid directory. Stop."
  }
}
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "[x] Check SourceDirectory"
Write-Verbose "    - SourceDirectory: $SourceDirectory"

# Get Modules folder
$ModuleDir = "$SourceDirectory\Modules"

# Get Modules directory.
$ModuleDir = "$SourceDirectory\Modules"

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

IF ($InstallDirectory -ne $SourceDirectory) {

  Copy-Item "$SourceDirectory\Source\*" -Destination "$InstallDirectory" -Recurse
  Copy-Item "$SourceDirectory\Source" -Destination "$InstallDirectory" -Recurse
  Copy-Item "$SourceDirectory\Tools" -Destination "$InstallDirectory" -Recurse
  # IF (-not (Test-Path $InstallDirectory\launchers)) {
  #   Write-Output "Create folder 'launchers'"
  #   New-Item -ItemType Directory -Path $InstallDirectory\launchers
  # }
}

# Set environment variables
Write-Verbose "Set `$env:PowerLauncher_InstallDir=$InstallDirectory"
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)
[Environment]::SetEnvironmentVariable('PowerLauncher_ModulesDir', $ModulePath, $Scope)


# Installl Modules
Write-Output "Install PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModulePath" -Recurse -Force
Write-Output "Install PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModulePath" -Recurse -Force

$SourceDir = $SourceDirectory

. $SourceDirectory\Tools\CreateShortcut.ps1 -s "$InstallDirectory" -a

$SourceDirectory = $SourceDir

. $SourceDirectory\Tools\CreateShortcut.ps1 -s "$InstallDirectory\Tools" -a -d $InstallDirectory -f "UpdateModules.ps1" -n "Pull-Modules.lnk" -p $SourceDir

$SourceDirectory = $SourceDir

. $SourceDirectory\Tools\CreateShortcut.ps1 -s "$InstallDirectory\Tools" -d $InstallDirectory -f "InstallSubModule.ps1" -n "New-Submodule.lnk"

Write-Output "Done. Software has been installed successfully."