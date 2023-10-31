#requires -Modules PowerLogger

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

# Dot source public/private functions
$PublicFunctions = @(Get-ChildItem -Path "$ScriptPath\public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$PrivateFunctions = @(Get-ChildItem -Path "$ScriptPath\private" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$UtilsFunctions = @(Get-ChildItem -Path "$ScriptPath\utils" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$ModuleTypes = @(Get-ChildItem -Path "$ScriptPath\ModuleTypes" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$PublicFunctions = $PublicFunctions + $ModuleTypes
$AllFunctions = $PublicFunctions + $PrivateFunctions + $UtilsFunctions
foreach ($Function in $AllFunctions) {
  try {
    . $Function.FullName
  }
  catch {
    throw ('Unable to dot source {0}' -f $Function.FullName)
  }
}

# Export public functions
Export-ModuleMember -Function $PublicFunctions.BaseName