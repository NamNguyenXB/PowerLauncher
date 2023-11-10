function Write-ModuleError {
  param(
    [Parameter()]
    $Module,

    [Parameter()]
    $Config,

    [Parameter()]
    $ModuleError
  )

  if ($null -eq $global:ModuleErrors) {
    $global:ModuleErrors = @{}
  }

  if ($null -ne $ModuleError) {
    if ($null -ne $Module) {
      $ModuleID = $Module.ID
    }

    if ($null -eq $ModuleID) {
      $ModuleID = (New-Guid).ToString();
    }

    $global:ModuleErrors[$ModuleID] = $ModuleError
  }

  Write-Error $ModuleError
}