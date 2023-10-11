function Install-Scripts{
  param(
    $SourceDirectory,
    $InstallDirectory
  )

  IF ($InstallDirectory -ne $SourceDirectory) {
    Copy-Item "$SourceDirectory\Templates" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
    Copy-Item "$SourceDirectory\Tools" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
    Copy-Item "$SourceDirectory\Icons" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  }

  if (-not(Test-Path "$InstallDirectory\configuration.json")) {
    Write-Output "{}" > "$InstallDirectory\configuration.json"
  }

  # Create Update Shortcut
  $UpdateScript = "$InstallDirectory\Tools\Update.ps1"
  $UpdateIconPath = "$InstallDirectory\Icons\Download.ico"
  New-Shortcut -f $UpdateScript -d $InstallDirectory -n "Update.lnk" -a -p $SourceDirectory -i $UpdateIconPath

  # Create New-Launcher shortcut
  $NewLauncherShortcutPath = "$InstallDirectory\New-Launcher.lnk"
  $NewLauncherCommand = "Import-Module PowerInstaller;"
  $NewLauncherCommand += "New-Launcher;"
  New-CmdShortcut -ShortcutPath $NewLauncherShortcutPath -Command $NewLauncherCommand -RunAsAdministrator
}