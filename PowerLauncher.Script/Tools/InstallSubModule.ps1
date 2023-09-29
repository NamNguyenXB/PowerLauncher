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
  $SourceDirectory,
  $DestinationDirectory,
  $TargetName = 'SubModule'
)

# Get Default InstallDir
$CopyScripts = 1

# Validation
Write-Output "Validating ..."
$IsValid = $true

# Validate $SourceDirectory
# $SourceDirectory is required.
# Defaults to the directory in which this script locates.
IF ($null -eq $SourceDirectory) {
  $ThisScriptDir = $PSScriptRoot
  IF ( $null -eq $ThisScriptDir) {
    $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
  }
  $SourceDirectory = $ThisScriptDir
}
Write-Output "`$SourceDirectory=$SourceDirectory"
IF ($null -eq $SourceDirectory) {
  $IsValid = $false
  throw "Validation Failed. `$SourceDirectory was not found. If you are remotely installing, Please specify -SourceDirectory parameter."
}

# Validate $DestinationDirectory
IF ( $null -eq $DestinationDirectory) {
  $DestinationDirectory = $SourceDirectory
}
Write-Output "`$DestinationDirectory=$DestinationDirectory"

# Validate $TargetName
IF (( $null -eq $TargetName) -or ("" -eq $TargetName)) {
  throw "TargetName cannot be null or Empty"
  $IsValid = $false
}

$TargetDirectory = $DestinationDirectory + "/" + $TargetName


IF ( -not $IsValid) {
  throw 'Validation Failed.'
}

IF ( -not $Force) {
  Read-Host "Validations passed. Press Enter to continue."
}
else {
  Write-Output "Validations passed."
}

Write-Output "Start installing..."

IF ($CopyScripts -eq 1) {
  Write-Output "Copy $SourceDirectory\Main.ps1 to $TargetDirectory"
  Copy-Item "$SourceDirectory\Main.ps1" -Destination $TargetDirectory

  Write-Output "Copy $SourceDirectory\launch.json to $TargetDirectory"
  Copy-Item "$SourceDirectory\launch.json" -Destination $TargetDirectory

  IF (-not (Test-Path $DestinationDirectory\launchers)) {
    Write-Output "Create folder 'launchers'"
    New-Item -ItemType Directory -Path $DestinationDirectory\launchers
  }

  Copy-Item "$SourceDirectory\launchers" -Destination $TargetDirectory -Recurse
}



Write-Output "Software has been installed successfully."