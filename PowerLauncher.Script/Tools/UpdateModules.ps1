param (
  [Alias("s", "source")]
  [Parameter(HelpMessage = "Specify the source directory. Must be an valid folder path.")]
  [ValidateScript({ Test-Path $_ })]
  $SourceDirectory
)

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Get PowerLauncher installed directory.
# $SoftwareDirectory = $env:PowerLauncher_InstallDir

# Get PowerLauncher installed Modules directory.
$ModulePath = $env:PowerLauncher_ModulesDir

$ModuleDir = "$SourceDirectory\Modules"

Write-Output "Install PowerLogger"
Copy-Item "$ModuleDir\PowerLogger" -Destination "$ModulePath" -Recurse -Force
Write-Output "Install PowerLauncher"
Copy-Item "$ModuleDir\PowerLauncher" -Destination "$ModulePath" -Recurse -Force

Read-Host -Prompt "Press Enter to exit"