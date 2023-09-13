$InstallFolder = Split-Path -Path ($MyInvocation.MyCommand.Path)
$MainFilePath = "$InstallFolder\Main.ps1"
$ShortcutFilePath = "$InstallFolder\Run.lnk"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFilePath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$MainFilePath'"""
$Shortcut.Save()

$bytes = [System.IO.File]::ReadAllBytes("$ShortcutFilePath")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$ShortcutFilePath", $bytes)