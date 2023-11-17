# Get this script path
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

# Get Scripts in public folder
$PublicFunctions = @(Get-ChildItem -Path "$ScriptPath\public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

# Get Scripts in private folder
$PrivateFunctions = @(Get-ChildItem -Path "$ScriptPath\private" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

# Dot source public & private functions
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