function Confirm-ModuleRun {
  param(
    $Module,
    [Switch]$IsSetup,
    [Switch]$Tail
  )

  if (($null -eq $Module) -or ($true -ne $Module.Run)) {
    return $false;
  }

  if (-not $IsSetup.IsPresent) {
    return $true;
  }

  if ($Tail.IsPresent -and ($null -ne $Module.Tail) -and ($true -eq $Module.Tail.Run)) {
    return $true;
  }

  if ((-not $Tail.IsPresent) -and ($null -ne $Module.Head) -and ($true -eq $Module.Head.Run)) {
    return $true;
  }

  return $false
}