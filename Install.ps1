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
  [Alias("s")]
  [ValidateSet("User", "Machine")]
  [Parameter(HelpMessage = "Specify the install scope. User or Machine.")]
  $Scope = "User",
  [Alias("d", "dir")]
  [Parameter(HelpMessage = "Specify the install directory. Must be an valid folder path.")]
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $InstallDir
)

# Get Default InstallDir
IF ( $null -eq $InstallDir) {
  $InstallDir = $PSScriptRoot
  IF ( $null -eq $InstallDir) {
    $InstallDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
  }
  Write-Verbose "Use Default InstallDir"
}

# Set environment variables
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDir, $Scope)
Write-Verbose "Write $InstallDir to `$env:PowerLauncher_InstallDir"

# Installl Modules
$CurrentModulePaths = [Environment]::GetEnvironmentVariable('PSModulePath', $Scope) -split ';'
$ModuleTargetPath = $CurrentModulePaths[0]
IF ($null -ne $ModuleTargetPath) {
  $ModuleDir = "$InstallDir\Modules"
  Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModuleTargetPath\PowerLogger" -Recurse
  Write-Verbose "Copy module PowerLogger to $ModuleTargetPath"
  Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModuleTargetPath\PowerLauncher" -Recurse
  Write-Verbose "Copy module PowerLauncher to $ModuleTargetPath"
}

# $MainFilePath = "$InstallDir\Main.ps1"
# $ShortcutFilePath = "$InstallDir\Run.lnk"
# 
# $WshShell = New-Object -comObject WScript.Shell
# $Shortcut = $WshShell.CreateShortcut($ShortcutFilePath)
# $Shortcut.TargetPath = "powershell.exe"
# $Shortcut.Arguments = "-command ""& '$MainFilePath'"""
# $Shortcut.Save()
# 
# Write-Verbose "Created shortcut $ShortcutFilePath for $MainFilePath"
# 
# $bytes = [System.IO.File]::ReadAllBytes("$ShortcutFilePath")
# $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
# [System.IO.File]::WriteAllBytes("$ShortcutFilePath", $bytes)
# 
# Write-Verbose "Allow the shortcut ($ShortcutFilePath) run as Administrator"