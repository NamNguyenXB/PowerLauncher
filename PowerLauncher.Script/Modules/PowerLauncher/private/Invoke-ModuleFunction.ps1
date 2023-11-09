function Invoke-ModuleFunction{
  param(
    $Module,
    $Config
  )

  $Type = $Module.Type
  $FunctionName = "Invoke-" + $Type

  # Get the function name.
  if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
    Install-ModuleType -ModuleType $Type -d $Config.InstallFolder + "\modules"

    if ($null -eq (Get-Command "$FunctionName" -EA SilentlyContinue)) {
      throw "Cannot get module function of the type $Type"
    }
  }

  # Use 'Call operator' to call the function.
  &"$FunctionName" $Module $Config
}