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
  $SourceDirectory = $null
)

# Get Install Directory
if ( $null -eq $InstallDirectory) {
  $InstallDirectory = Read-Host "Install to"
  if (-not (Test-Path $InstallDirectory)) {
    throw "Invalid directory. Stop."
  }
}
else {
  Write-Information "Install to: $InstallDirectory"
}

# Get script directory
$ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)

# Get Project Source Dỉrectory
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$ThisScriptDir\.."
}

# Import PowerInstaller
if(-not (Test-Path "$SourceDirectory\Modules\PowerInstaller\PowerInstaller.psm1")){
  throw "Module PowerInstaller was not found."
}
Import-Module "$SourceDirectory\Modules\PowerInstaller"

Install-PowerLauncher -SourceDirectory $SourceDirectory -InstallDirectory $InstallDirectory -Scope $Scope

Read-Host "Done. Software has been installed successfully"