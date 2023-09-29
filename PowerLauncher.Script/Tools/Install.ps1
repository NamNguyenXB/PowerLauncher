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
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $InstallDirectory,
  [Alias("s", "source")]
  [Parameter(HelpMessage = "Specify the source directory. Must be an valid folder path.")]
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $SourceDirectory,
  [Alias("f")]
  [switch]$Force
)

$Verbose = [bool]$PSBoundParameters['Verbose']

# Get Default InstallDir
$CopyScripts = 1

# Validation
Write-Output "Validating ..."
$IsValid = $true

# Validate $SourceDirectory
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

# Validate $ModuleDir
$ModuleDir = "$SourceDirectory\Modules"
Write-Output "`$ModuleDir=$ModuleDir"
IF (-not (Test-Path $ModuleDir)) {
  $IsValid = $false
  throw "`$ModuleDir($ModuleDir) is not a folder"
}

IF (-not(Test-Path "$ModuleDir\PowerLogger")) {
  $IsValid = $false
  throw "Module PowerLogger was not found."
}

IF (-not(Test-Path "$ModuleDir\PowerLauncher")) {
  $IsValid = $false
  throw "Module PowerLauncher was not found."
}

IF ( $null -eq $InstallDirectory) {
  $InstallDirectory = $SourceDirectory
  $CopyScripts = 0
}

Write-Output "`$InstallDirectory=$InstallDirectory"

$CurrentModulePaths = $env:PSModulePath -split ';'
IF ( $CurrentModulePaths.Length -lt 1) {
  $IsValid = $false
  throw "`$env:PSModulePath is empty."
}

$ModuleTargetPath = $CurrentModulePaths[0]
Write-Output "`$ModuleTargetPath=$ModuleTargetPath"
IF (-not (Test-Path $ModuleTargetPath)) {
  $IsValid = $false
  throw "`$ModuleTargetPath($ModuleTargetPath) is not a folder"
}

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
  Write-Output "Copy $SourceDirectory\Main.ps1 to $InstallDirectory"
  Copy-Item "$SourceDirectory\Main.ps1" -Destination $InstallDirectory

  Write-Output "Copy $SourceDirectory\launch.json to $InstallDirectory"
  Copy-Item "$SourceDirectory\launch.json" -Destination $InstallDirectory

  Write-Output "Copy $SourceDirectory\README.md to $InstallDirectory"
  Copy-Item "$SourceDirectory\README.md" -Destination $InstallDirectory

  IF (-not (Test-Path $InstallDirectory\launchers)) {
    Write-Output "Create folder 'launchers'"
    New-Item -ItemType Directory -Path $InstallDirectory\launchers
  }
}

# Set environment variables
Write-Output "Set `$env:PowerLauncher_InstallDir=$InstallDirectory"
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)


# Installl Modules
Write-Output "Installing Modules to the folder $ModuleTargetPath"
Write-Output "Installing PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModuleTargetPath" -Recurse -Force
Write-Output "Installing PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModuleTargetPath" -Recurse -Force

$MainFilePath = "$InstallDirectory\Main.ps1"
$ShortcutFilePath = "$InstallDirectory\Run.lnk"
 
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFilePath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$MainFilePath'"""
$Shortcut.Save()
 
Write-Output "Created shortcut $ShortcutFilePath for $MainFilePath"
 
$bytes = [System.IO.File]::ReadAllBytes("$ShortcutFilePath")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$ShortcutFilePath", $bytes)
 
Write-Output "Allow the shortcut ($ShortcutFilePath) run as Administrator"

Write-Output "Software has been installed successfully."