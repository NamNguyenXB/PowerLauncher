param (
  [Alias("s", "source")]
  [Parameter(HelpMessage = "Specify the source directory. Must be an valid folder path.")]
  [ValidateScript({ Test-Path $_ })]
  $SourceDirectory
)

Import-Module PowerInstaller

# Get this script directory.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Re-Install Power-Modules
$PSModulePath = $env:PowerLauncher_ModulesDir
Install-PowerModules -SourceDirectory $SourceDirectory -PSModulePath $PSModulePath

# # Get PowerLauncher installed directory.
# $InstallDirectory = $env:PowerLauncher_InstallDir
# $LaunchersDirectory = "$InstallDirectory\Launchers"
# if(Test-Path $LaunchersDirectory){
#   Get-ChildItem $LaunchersDirectory | Foreach-Object{
#     $LauncherDirectory = $_.FullName
#   }
# }

Read-Host -Prompt "Press Enter to exit"