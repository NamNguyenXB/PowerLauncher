function Confirm-ModuleRun{
  param(
    $Module
  )

  $CanRun = $false
  if(($null -ne $Module) -and ($Module.Run)){
    $CanRun = $true
  }

  return $CanRun
}