
function Get-ObjectFromJsonFile {
  param (
    $Path,
    $DefaultValue = $null
  )

  if ($null -eq $Path) {
    return $DefaultValue;
  }

  return Get-Content $Path | ConvertFrom-Json;
}