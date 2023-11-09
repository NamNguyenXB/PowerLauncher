function Write-ModuleError{
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config,

    [Parameter()]
    $ModuleError
  )

  Write-Error $ModuleError
}