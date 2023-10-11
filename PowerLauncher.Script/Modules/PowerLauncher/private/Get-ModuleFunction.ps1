function Get-ModuleFunction {
  param(
    $Module,
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