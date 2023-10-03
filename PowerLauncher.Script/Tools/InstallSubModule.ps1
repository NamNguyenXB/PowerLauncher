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
  $TargetName
)

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

$TargetName = Read-Host "New sub-module name"
if($null -eq $TargetName){
  throw "The name is required!"
}

# Get PowerLauncher installed directory.
$SoftwareDirectory = $env:PowerLauncher_InstallDir

# Get default source directory.
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$SoftwareDirectory"
}
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$ThisScriptDir\.."
}

# Get default destination directory.
IF ($null -eq $DestinationDirectory) {
  $DestinationDirectory = $SourceDirectory
}

IF( $SourceDirectory -ne "$DestinationDirectory\$TargetName"){
  Copy-Item "$SourceDirectory\Source" -Destination "$DestinationDirectory\SubLaunchers\$TargetName" -Recurse
  . $SourceDirectory\Tools\CreateShortcut.ps1 -a -s "$DestinationDirectory\SubLaunchers\$TargetName" -n "$TargetName.lnk"
}