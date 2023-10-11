function Install-PowerModules{
  param(
    $SourceDirectory,
    $PSModulePath
  )

  Test-PowerModules -SourceDirectory $SourceDirectory

  $ModuleList = Get-PowerModuleList
  

  $ModuleList | ForEach-Object{
    Copy-Item "$SourceDirectory\Modules\$_" -Destination "$PSModulePath" -Recurse -Force -ErrorAction SilentlyContinue
  }
}