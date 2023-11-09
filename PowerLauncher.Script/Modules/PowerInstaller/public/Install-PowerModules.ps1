function Install-PowerModules {
  param(
    $SourceDirectory,
    $PSModulePath
  )

  Test-PowerModules -SourceDirectory $SourceDirectory

  $ModuleList = Get-PowerModuleList

  $ModuleList | ForEach-Object {
    $Path = "$SourceDirectory\Modules\$_"
    $Destination = "$PSModulePath\$_"
    if (Test-Path $Destination) {
      Remove-Item "$Destination\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    Copy-Item -Path $Path -Destination "$PSModulePath" -Recurse -Force -ErrorAction SilentlyContinue
  }
}