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

  # Set environment variables
  [Environment]::SetEnvironmentVariable('PowerLauncher_ModulesDir', $PSModulePath, $Scope)
  [Environment]::SetEnvironmentVariable('PowerLauncher_InstallDir', $InstallDirectory, $Scope)
}