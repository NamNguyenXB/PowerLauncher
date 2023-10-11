function Get-PSModulePath {

  # Get PSModulePaths
  $PSModulePath = $env:PSModulePath -split ';' | Select-Object -First 1 

  IF (-not (Test-Path $PSModulePath)) {
    throw "`$ModulePath($PSModulePath) is not a folder"
  }

  return $PSModulePath
}