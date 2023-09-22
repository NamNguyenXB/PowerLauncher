#requires -Modules PowerLogger

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

# Dot source public/private functions
$PublicFunctions = @(Get-ChildItem -Path "$ScriptPath\public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$PrivateFunctions = @(Get-ChildItem -Path "$ScriptPath\private" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$Launchers = @(Get-ChildItem -Path "$ScriptPath\launchers" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)
$PublicFunctions = $PublicFunctions + $Launchers
$AllFunctions = $PublicFunctions + $PrivateFunctions
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