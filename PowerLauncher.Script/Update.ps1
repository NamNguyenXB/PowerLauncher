$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

Start-Process powershell -ArgumentList "-file $ThisScriptDir\Tools\Update.ps1 -SourceDirectory $ThisScriptDir" -Verb RunAs