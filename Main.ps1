$InstallFolder = $env:PowerLauncher_InstallDir
if($null -eq $InstallFolder){
  $InstallFolder = [Environment]::GetEnvironmentVariable('PowerLauncher_InstallDir', "User")
}
if($null -eq $InstallFolder){
  $InstallFolder = [Environment]::GetEnvironmentVariable('PowerLauncher_InstallDir', "Machine")
}
IF ( $null -eq $InstallFolder) {
  $InstallFolder = $PSScriptRoot
}
IF ( $null -eq $InstallFolder){
  $InstallFolder = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Import Modules
Import-Module "$InstallFolder/Modules/PowerLogger"
Import-Module "$InstallFolder/Modules/PowerLauncher"

Write-Box -t "Begin"
Write-Output "|  Root Folder: $InstallFolder"

# Load Launch.json file
$Launch = Get-Content "$InstallFolder/launch.json" | ConvertFrom-Json

$SetupLaunchers = $Launch.SetupLaunchers
$Launchers = $Launch.Launchers
$Config = $Launch.Configuration

# Add the InstallFolder to the $Config
if (!$Config.InstallFolder) {
  $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
}

Write-Output $Config

# Run LauncherHeads
Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $true

# Run Launchers
Invoke-Launcher -l $Launchers -c $Config

# Run LauncherTails
Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $false

Write-Box -t "End  "


if (!$Config.CloseWhenDone) {
  Read-Host -Prompt "Press Enter to exit"
}
