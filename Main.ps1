$Verbose = 1
$InstallFolder = Split-Path -Path ($MyInvocation.MyCommand.Path)
$ModulesFolder = "$InstallFolder/Modules"

# Import Modules
Import-Module "$ModulesFolder/Invoke-Launcher"


if ($Verbose = 1) {
  Write-Begin
  Write-Output "|  Root Folder: $InstallFolder"
}


# Load Launch.json file
$LaunchFile = "$InstallFolder/launch.json"
$Launch = Get-Content $LaunchFile | ConvertFrom-Json


$SetupLaunchers = $Launch.SetupLaunchers
$Launchers = $Launch.Launchers
$Config = $Launch.Configuration

if (!$Config.InstallFolder) {
  $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
}

Write-Output $Config

$SetupLaunchers | ForEach-Object {
  $SetupLauncher = $_
  if ($SetupLauncher.Run) {
    $Launcher = $SetupLauncher.LauncherHead
    Invoke-Launcher $Launcher $Config
  }
}

$Launchers | ForEach-Object {
  $Launcher = $_
  Invoke-Launcher $Launcher $Config
}

$SetupLaunchers | ForEach-Object {
  $SetupLauncher = $_
  if ($SetupLauncher.Run) {
    $Launcher = $SetupLauncher.LauncherTail
    Invoke-Launcher $Launcher $Config
  }
}

if ($Verbose = 1) {
  Write-End
}


if (!$Config.CloseWhenDone) {
  Read-Host -Prompt "Press Enter to exit"
}
