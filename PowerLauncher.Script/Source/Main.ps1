$InstallFolder = $env:PowerLauncher_InstallDir

# Import Modules
Import-Module "PowerLogger"
Import-Module "PowerLauncher"

Write-Box -t "Begin"
Write-Content "Root Folder: $InstallFolder" -l 1 -p "|"

$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Load Launch.json file
$Launch = Get-Content "$ThisScriptDir/launch.json" | ConvertFrom-Json

$SetupLaunchers = $Launch.SetupLaunchers
$Launchers = $Launch.Launchers
$Config = $Launch.Configuration

# Add the InstallFolder to the $Config
if (-not $Config.InstallFolder) {
  $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
}

Write-Content "Configurations: $Config" -l 1 -p "|"

# Run LauncherHeads
Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $true

# Run Launchers
Invoke-Launchers -l $Launchers -c $Config

# Run LauncherTails
Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $false

Write-Box -t "End  "


if (-not $Config.CloseWhenDone) {
  Read-Host -Prompt "Press Enter to exit"
}
