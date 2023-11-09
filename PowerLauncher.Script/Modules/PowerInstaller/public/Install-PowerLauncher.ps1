function Install-PowerLauncher {
  param(
    [ValidateScript({ Test-Path $_ })]
    $SourceDirectory,

    [ValidateScript({ Test-Path $_ })]
    $InstallDirectory,

    [ValidateSet("User", "Machine")]
    $Scope = "User"
  )

  # Install Power Modules
  $PSModulePath = Get-PSModulePath
  Install-PowerModules -SourceDirectory $SourceDirectory -PSModulePath $PSModulePath

  # Install scripts
  Install-Scripts -SourceDirectory $SourceDirectory -InstallDirectory $InstallDirectory

  # Create Update Shortcut
  $UpdateScript = "$InstallDirectory\Tools\Update.ps1"
  $UpdateIconPath = "$InstallDirectory\Icons\Download.ico"
  New-Shortcut -f $UpdateScript -d $InstallDirectory -n "Update.lnk" -a -p $SourceDirectory -i $UpdateIconPath

  # Create New-Launcher shortcut
  $NewLauncherShortcutPath = "$InstallDirectory\New-Launcher.lnk"
  $NewLauncherCommand = "Import-Module PowerInstaller;"
  $NewLauncherCommand += "New-Launcher;"
  New-CmdShortcut -ShortcutPath $NewLauncherShortcutPath -Command $NewLauncherCommand -RunAsAdministrator

  # Set environment variables
  [Environment]::SetEnvironmentVariable('PowerLauncher_ModulesDir', $PSModulePath, $Scope)
  [Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)
}