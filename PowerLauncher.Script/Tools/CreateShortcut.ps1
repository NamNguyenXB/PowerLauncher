<#
.SYNOPSIS
Create a shortcut that can run a Powershell script in the administrator mode.

.PARAMETER SourceFilePath

.PARAMETER DestinationDirectory

.PARAMETER ShortcutName


.EXAMPLE

#>

param (
  [Alias("s")]
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $SourceFilePath,
  [Alias("d")]
  [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
  $DestinationDirectory,
  [Alias("n")]
  $ShortcutName = "Run.lnk",
  [Alias("p")]
  $ScriptParameters = "",
  [Alias("a")]
  [switch]$AdminRequired
)

# Initialize variables
$IsValid = $true
$lineLength = 120
$blankLine = " " * $lineLength

# Get folder of this script.
$ThisScriptDir = $PSScriptRoot
IF ( $null -eq $ThisScriptDir) {
  $ThisScriptDir = Split-Path -Path ($MyInvocation.MyCommand.Path)
}

# Get default SourceFilePath
IF ($null -eq $SourceFilePath) {
  $SourceFilePath = "$ThisScriptDir\Main.ps1"
}

# Get default Destination Directory
IF ( $null -eq $DestinationDirectory) {
  $DestinationDirectory = Split-Path -Parent $SourceFilePath
}

# Get destination file path
$ShortcutPath = "$DestinationDirectory\$ShortcutName"

# Validation

# Validate $SourceFilePath
# $SourceFilePath is required.
# Defaults to the directory in which this script locates.
$pos = $host.UI.RawUI.CursorPosition
Write-Verbose "[ ] Check SourceFilePath"
IF (($null -eq $SourceFilePath) -or (-not (Test-Path $SourceFilePath))) {
  $IsValid = $false
  throw "Invalid. `$SourceFilePath ($SourceFilePath) is null or not a valid file path."
}
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "[x] Check SourceFilePath"
Write-Verbose "    - SourceFilePath: $SourceFilePath"


# Validate $DestinationDirectory
$pos = $host.UI.RawUI.CursorPosition
Write-Verbose "[ ] Check ShortcutName"
IF (($null -eq $ShortcutName) -or ("" -eq $ShortcutName)) {
  $IsValid = $false
  throw "Invalid. `$ShortcutName ($ShortcutName) is null or not empty."
}
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "[x] Check ShortcutName"

# Thow exception if vailading failed.
IF ( -not $IsValid) {
  throw 'Validation Failed.'
}

# Inform the validation result
Write-Verbose "Validation completed. No error found."

# Create a new shortcut file
$pos = $host.UI.RawUI.CursorPosition
Write-Verbose "Creating the shortcut..."
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-command ""& '$SourceFilePath'  $ScriptParameters"""
$Shortcut.Save()
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose $blankLine
$host.UI.RawUI.CursorPosition = $pos
Write-Verbose "Created a new shortcut: $ShortcutPath"

# Modify the shortcut's access privilege
if($AdminRequired){
  $pos = $host.UI.RawUI.CursorPosition
  Write-Verbose "Modifying the shortcut..."
  $bytes = [System.IO.File]::ReadAllBytes("$ShortcutPath")
  $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
  [System.IO.File]::WriteAllBytes("$ShortcutPath", $bytes)
  $host.UI.RawUI.CursorPosition = $pos
  Write-Verbose $blankLine
  $host.UI.RawUI.CursorPosition = $pos
  Write-Verbose "Modified the shortcut ($ShortcutPath)"
}

# Completed! Write log
Write-Verbose "Done! The shortcut was created successfully."
