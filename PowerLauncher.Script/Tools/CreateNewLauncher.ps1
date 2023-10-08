<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER Scope
Install Scope.

.PARAMETER InstallDir
Install Directory (Optional)

.EXAMPLE

#>

param (
  $SourceDirectory,
  $DestinationDirectory,
  $SubModuleName
)

Import-Module "PowerInstaller"

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

$SubModuleName = Read-Host "New sub-module name"
if($null -eq $SubModuleName){
  throw "The name is required!"
}

# Get PowerLauncher installed directory.
$SoftwareDirectory = $env:PowerLauncher_InstallDir

# Get default source directory.
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$SoftwareDirectory"
  IF ($null -eq $SourceDirectory) {
    $SourceDirectory = "$ThisScriptDir\.."
  }
}

# Get default destination directory.
IF ($null -eq $DestinationDirectory) {
  $DestinationDirectory = $SourceDirectory
}

$SubModuleDirectory = "$DestinationDirectory\SubLaunchers\$SubModuleName"

IF( $SourceDirectory -ne "$SubModuleDirectory"){
  Copy-Item "$SourceDirectory\Source" -Destination "$SubModuleDirectory" -Recurse -ErrorAction SilentlyContinue
  New-Shortcut -a -f "$SubModuleDirectory\Main.ps1" -n "$SubModuleName.lnk"
}