<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER Scope
Install Scope.

.PARAMETER InstallDir
Install Directory (Optional)

.EXAMPLE

#>

#requires -RunAsAdministrator

param (
  [Alias("s")]
  $SourceDirectory,
  [Alias("d")]
  $DestinationDirectory,
  [Alias("f")]
  $FileName = "Main.ps1",
  [Alias("n")]
  $ShortcutName = "Run.lnk"
)

# Validation
$IsValid = $true
$lineLength = 120
$blankLine = " " * $lineLength
$dashLine = "-" * $lineLength
$shortDashLine = "-" * ($lineLength / 2)


#Write-Output "$dashLine"

# Validate $SourceDirectory
# $SourceDirectory is required.
# Defaults to the directory in which this script locates.
$origpos = $host.UI.RawUI.CursorPosition
Write-Output "[CHK] Validating SourceDirectory..."
IF ($null -eq $SourceDirectory) {
  $ThisScriptDir = $PSScriptRoot
  IF ( $null -eq $ThisScriptDir) {
    $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
  }
  $SourceDirectory = $ThisScriptDir
}

IF ($null -eq $SourceDirectory) {
  $IsValid = $false
  throw "Validation Failed. `$SourceDirectory was not found. If you are remotely installing, Please specify -SourceDirectory parameter."
}
$host.UI.RawUI.CursorPosition = $origpos
Write-Output $blankLine
$host.UI.RawUI.CursorPosition = $origpos
Write-Output "[CHK] SourceDirectory - Valid"

# Validate $DestinationDirectory
$origpos = $host.UI.RawUI.CursorPosition
Write-Output "[CHK] Validating DestinationDirectory..."
IF ( $null -eq $DestinationDirectory) {
  $DestinationDirectory = $SourceDirectory
}
$host.UI.RawUI.CursorPosition = $origpos
Write-Output $blankLine
$host.UI.RawUI.CursorPosition = $origpos
Write-Output "[CHK] DestinationDirectory - Valid"


IF ( -not $IsValid) {
  throw 'Validation Failed.'
}

Write-Output "[CHK] Validation completed. No error found."
#Write-Output $dashLine

$origpos = $host.UI.RawUI.CursorPosition
Write-Output "[INF] Creating the shortcut $ShortcutFilePath for $MainFilePath..."

$MainFilePath = "$SourceDirectory\$FileName"
$ShortcutFilePath = "$DestinationDirectory\$ShortcutName"
 
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutFilePath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$MainFilePath'"""
$Shortcut.Save()

$host.UI.RawUI.CursorPosition = $origpos
Write-Output $blankLine
$host.UI.RawUI.CursorPosition = $origpos
Write-Output "[INF] Created shortcut $ShortcutFilePath for $MainFilePath"
 

$origpos = $host.UI.RawUI.CursorPosition
Write-Output "[INF] Modifying the shortcut ($ShortcutFilePath)..."
$bytes = [System.IO.File]::ReadAllBytes("$ShortcutFilePath")
$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
[System.IO.File]::WriteAllBytes("$ShortcutFilePath", $bytes)
 
$host.UI.RawUI.CursorPosition = $origpos
Write-Output $blankLine
$host.UI.RawUI.CursorPosition = $origpos
Write-Output "[INF] Allow the shortcut ($ShortcutFilePath) run as Administrator"
Write-Output "[INF] Done! The shortcut was created successfully."

#Write-Output $dashLine
