function Confirm-ModuleRun {
  param(
    $Module
  )

  if (($null -ne $Module) -and ($true -eq $Module.Run)) {
    return $true;
  }

  return $false
}