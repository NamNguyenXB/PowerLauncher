function Test-PowerModules{
  param(
    $SourceDirectory
  )

  if(-not (Test-Path "$SourceDirectory\Modules")){
    throw "'Modules' folder was not found."
  }

  $ModuleList = Get-PowerModuleList

  $ModuleList | ForEach-Object {
    if((-not (Test-Path "$SourceDirectory\Modules\$_")) -or -not (Test-Path "$SourceDirectory\Modules\$_\$_.psm1")){
      throw "Module '$_' was not found."
    }
  }
}