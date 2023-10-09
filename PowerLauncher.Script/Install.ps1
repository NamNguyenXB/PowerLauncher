$ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)

Start-Process powershell -ArgumentList "-file $ThisScriptDir\Tools\Install.ps1" -Verb RunAs