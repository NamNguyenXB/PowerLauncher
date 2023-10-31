<#
.SYNOPSIS
Start a list of modules

.PARAMETER Modules
Modules to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function Start-Modules {
  param(
    $Modules,
    $Config,
    [switch] $IsSetup,
    [switch] $Head
  )
  if (($null -ne $Modules) -and ($Modules.Length -gt 0)) {
    $Modules | ForEach-Object {
      $Module = $_
      if ($Module.Run) {
        if ( $IsSetup.IsPresent) {
          if ( $Head.IsPresent) {
            $Module = $Module.LauncherHead
          }
          else {
            $Module = $Module.LauncherTail
          }
        }
        
        Start-Module -Module $Module -Config $Config
      }
    }
  }
}