<#
.SYNOPSIS
Create new shortcut.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function New-CmdShortcut {
  param(
    $ShortcutPath,
    $Command,
    $Parameters="",
    [switch]$RunAsAdministrator
  )

  $WshShell = New-Object -comObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
  $Shortcut.TargetPath = "powershell.exe"
  $Shortcut.Arguments = "-command ""$Command $Parameters"""
  $Shortcut.Save()
  if($RunAsAdministrator){
    $bytes = [System.IO.File]::ReadAllBytes("$ShortcutPath")
    $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes("$ShortcutPath", $bytes)
  }
}