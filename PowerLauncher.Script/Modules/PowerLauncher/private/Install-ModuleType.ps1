<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Install-ModuleType {
  param(
    [Alias("t", "type")]
    [Parameter(Mandatory)]
    $ModuleType,

    [Alias("d", "dir", "directory")]
    $ModuleTypesDirectory
  )

  # Get FunctionName
  $FunctionName = "Invoke-" + $ModuleType

  if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    $Function = @(Get-ChildItem -Path "$ModuleTypesDirectory" -Filter "$FunctionName".ps1 -Recurse -ErrorAction SilentlyContinue)
    try {
      . $Function.FullName
    }
    catch {
      throw ('Unable to dot source {0}' -f $Function.FullName)
    }
  }
}