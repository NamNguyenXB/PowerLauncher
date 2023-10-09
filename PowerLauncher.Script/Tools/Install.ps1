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

# Get Source Dỉrectory
IF ($null -eq $SourceDirectory) {
  $ThisScriptDir = $PSScriptRoot
  IF ( $null -eq $ThisScriptDir) {
    $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
  }
  $SourceDirectory = "$ThisScriptDir\.."
}

# Get Module list
$PSModules = $("PowerLogger", "PowerLauncher", "PowerInstaller")

# Get Install Directory
IF ( $null -eq $InstallDirectory) {
  $InstallDirectory = Read-Host "Install to"
  If (-not (Test-Path $InstallDirectory)) {
    throw "Invalid directory. Stop."
  }
}
else {
  Write-Output "Install to: $InstallDirectory"
}

# Get Modules directory.
$ModuleDir = "$SourceDirectory\Modules"
Write-Output "Modules directory: $ModuleDir"

# Check Modules
IF (-not (Test-Path $ModuleDir)) {
  throw "`$ModuleDir($ModuleDir) is not a folder"
}
IF (-not(Test-Path "$ModuleDir\PowerLogger")) {
  throw "Module PowerLogger is not found."
}
IF (-not(Test-Path "$ModuleDir\PowerLauncher")) {
  throw "Module PowerLauncher is not found."
}
IF (-not(Test-Path "$ModuleDir\PowerInstaller")) {
  throw "Module PowerInstaller is not found."
}

# Get directory to install modules.
$ModulePaths = $env:PSModulePath -split ';'
IF ( $ModulePaths.Length -lt 1) {
  throw "`$env:PSModulePath is empty."
}

$ModulePath = $ModulePaths[0]
IF (-not (Test-Path $ModulePath)) {
  throw "`$ModulePath($ModulePath) is not a folder"
}

$Answer = Read-Host "Ready to Install. Continue[Y/N]? (Defaults to Y)"
IF ($Answer -eq 'N') {
  return;
}

Write-Output "Import Module PowerInstaller"

Import-Module "$ModuleDir\PowerInstaller"

IF ($InstallDirectory -ne $SourceDirectory) {
  Copy-Item "$SourceDirectory\Templates" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  Copy-Item "$SourceDirectory\Tools" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  Copy-Item "$SourceDirectory\Icons" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
}

if (-not(Test-Path "$InstallDirectory\configuration.json")) {
  Write-Output "{}" > "$InstallDirectory\configuration.json"
}

# Set environment variables
Write-Output "Set `$env:PowerLauncher_InstallDir=$InstallDirectory"
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)
Write-Output "Set `$env:PowerLauncher_ModulesDir=$ModulePath"
[Environment]::SetEnvironmentVariable('PowerLauncher_ModulesDir', $ModulePath, $Scope)


# Installl Modules
Write-Output "Modules are installed to: $ModulePath"
Write-Output "Install PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Install PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue
Write-Output "Install PowerInstaller"
Copy-Item "$ModuleDir\PowerInstaller" -Destination "$ModulePath" -Recurse -Force -ErrorAction SilentlyContinue

Write-Output "Create shortcut Update.lnk"
New-Shortcut -f "$InstallDirectory\Tools\Update.ps1" -d $InstallDirectory -n "Update.lnk" -a -p $SourceDirectory -i "$InstallDirectory\Icons\Download.ico"

Write-Output "Create shortcut New-Launcher.lnk"
New-CmdShortcut -ShortcutPath "$InstallDirectory\New-Launcher.lnk" -Command "Import-Module PowerInstaller;New-Launcher" -RunAsAdministrator

Read-Host "Done. Software has been installed successfully"