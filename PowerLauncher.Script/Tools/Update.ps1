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
Install-PSModules -SourceDirectory $SourceDirectory -PSModulePath $PSModulePath

Read-Host -Prompt "Press Enter to exit"