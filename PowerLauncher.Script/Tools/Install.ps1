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

$lineLength = 120
$blankLine = " " * $lineLength

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Get $SourceDirectory
IF ($null -eq $SourceDirectory) {
  $SourceDirectory = "$ThisScriptDir\..\"
}

# Validate $SourceDirectory
$pos = $host.UI.RawUI.CursorPosition
Write-Verbose "[ ] Check SourceDirectory"
IF ($null -eq $SourceDirectory) {
  throw "Validation Failed. `$SourceDirectory was not found. If you are remotely installing, Please specify -SourceDirectory parameter."
}
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "[x] Check SourceDirectory"
Write-Verbose "    - SourceDirectory: $SourceDirectory"

# Get Modules folder
$ModuleDir = "$SourceDirectory\Modules"

# Validate $ModuleDir
$pos = $host.UI.RawUI.CursorPosition
Write-Verbose "[ ] Check Modules"
IF (-not (Test-Path $ModuleDir)) {
  throw "`$ModuleDir($ModuleDir) is not a folder"
}
IF (-not(Test-Path "$ModuleDir\PowerLogger")) {
  throw "Module PowerLogger was not found."
}
IF (-not(Test-Path "$ModuleDir\PowerLauncher")) {
  throw "Module PowerLauncher was not found."
}
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "[x] Check Modules"
Write-Verbose "    - ModuleDir: $ModuleDir"
Write-Verbose "    - [x] PowerLogger"
Write-Verbose "    - [x] PowerLauncher"

# Get PSModulePath
$CurrentModulePaths = $env:PSModulePath -split ';'
IF ( $CurrentModulePaths.Length -lt 1) {
  throw "`$env:PSModulePath is empty."
}

# Get ModuleTargetPath
$ModuleTargetPath = $CurrentModulePaths[0]
IF (-not (Test-Path $ModuleTargetPath)) {
  throw "`$ModuleTargetPath($ModuleTargetPath) is not a folder"
}

# Waiting user input before installing
IF ( -not $Force) {
  Read-Host "Ready to Install! Press Enter to continue..."
}
else {
  Write-Verbose "Ready to Install!"
}

# Get $InstallDirectory
IF ( $null -eq $InstallDirectory) {
  $InstallDirectory = $SourceDirectory
}


IF ($InstallDirectory -ne $SourceDirectory) {

  IF (-not (Test-Path $InstallDirectory\Source)) {
    Write-Verbose "Create folder 'Source'"
    New-Item -ItemType Directory -Path $InstallDirectory\Source
  }
  Write-Verbose "Copy Source\Main.ps1"
  Copy-Item "$SourceDirectory\Source\Main.ps1" -Destination $InstallDirectory\Source

  Write-Verbose "Copy Source\launch.json"
  Copy-Item "$SourceDirectory\Source\launch.json" -Destination $InstallDirectory\Source

  IF (-not (Test-Path $InstallDirectory\Run)) {
    Write-Verbose "Create folder 'Run'"
    New-Item -ItemType Directory -Path $InstallDirectory\Run
  }
  Copy-Item "$SourceDirectory\Source\Main.ps1" -Destination $InstallDirectory\Run
  Copy-Item "$SourceDirectory\Source\launch.json" -Destination $InstallDirectory\Run

  IF (-not (Test-Path $InstallDirectory\launchers)) {
    Write-Verbose "Create folder 'launchers'"
    New-Item -ItemType Directory -Path $InstallDirectory\launchers
  }

  IF (-not (Test-Path $InstallDirectory\Tools)) {
    Write-Verbose "Create folder 'Tools'"
    New-Item -ItemType Directory -Path $InstallDirectory\Tools
  }
  Write-Verbose "Copy Tools\CreateShortcut.ps1"
  Copy-Item "$SourceDirectory\Tools\CreateShortcut.ps1" -Destination $InstallDirectory\Tools
  Write-Verbose "Copy Tools\InstallSubModule.ps1"
  Copy-Item "$SourceDirectory\Tools\InstallSubModule.ps1" -Destination $InstallDirectory\Tools
}

# Set environment variables
Write-Verbose "Set `$env:PowerLauncher_InstallDir=$InstallDirectory"
[Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)


# Installl Modules
Write-Verbose "Install Modules"
Write-Verbose "     - Install PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModuleTargetPath" -Recurse -Force
Write-Verbose "     - Install PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModuleTargetPath" -Recurse -Force

# Create shortcut to run
. "$InstallDirectory\Tools\CreateShortcut.ps1" -s "$InstallDirectory\Run\Main.ps1"

Write-Verbose "Software has been installed successfully."