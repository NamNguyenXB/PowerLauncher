<#
.SYNOPSIS
Get executable function of a Power Module

.PARAMETER Module
Module to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Get-ModuleFunction {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config
  )

  $Type = $Module.Type
  $FunctionName = "Invoke-" + $Type

  if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    Install-LauncherType -t $Type -d $Config.InstallFolder + "\launchers"
  }

  if ($null -ne (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    throw "Cannot get module function of the type $Type"
  }

  return $FunctionName
}