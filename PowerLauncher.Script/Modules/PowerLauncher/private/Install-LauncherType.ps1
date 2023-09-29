<#
.SYNOPSIS
Invoke a launcher.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Install-LauncherType {
  param(
    [Alias("t", "type")]
    [Parameter(Mandatory)]
    $LauncherType,
    [Alias("d", "dir", "directory")]
    $LauncherDir
  )

  # Get FunctionName
  $FunctionName = "Invoke-" + $LauncherType
  if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    $Function = @(Get-ChildItem -Path "$LauncherDir" -Filter "$FunctionName".ps1 -Recurse -ErrorAction SilentlyContinue)
    try {
      . $Function.FullName
    }
    catch {
      throw ('Unable to dot source {0}' -f $Function.FullName)
    }
  }
}