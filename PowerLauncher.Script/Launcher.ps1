<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER ConfigurationPath
Path of the configuration file.

.PARAMETER SetupPath
Path of the Launcher information file.

.PARAMETER ModulesPath
Path of the Launcher information file.

.EXAMPLE

#>

#requires -RunAsAdministrator

param (
  $ConfigurationPath,
  $SetupPath,
  $ModulesPath
)

Start-Launcher -ConfigurationPath $ConfigurationPath -SetupPath $SetupPath -ModulesPath $ModulesPath
