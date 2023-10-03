<#
.SYNOPSIS
Create new shortcut.

.PARAMETER Launcher
Launcher to run.

.PARAMETER Config
Run configuration.

.EXAMPLE

#>
function New-Shortcut {
  param(
    [Alias("f", "File")]
    [ValidateScript({ Test-Path $_ })]
    [Parameter(HelpMessage = "Path of the source file.")]
    $FilePath,
    [Alias("d")]
    [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
    [Parameter(HelpMessage = "Path of the shortcut directory. Defaults to the source directory.")]
    $ShortcutDirectory,
    [Alias("n", "name")]
    [Parameter(HelpMessage = "Name of the shortcut file.")]
    [String]$ShortcutName,
    [Alias("p")]
    [Parameter(HelpMessage = "Parameters passed to the sort file through this shortcut.")]
    $ScriptParameters = "",
    [Alias("a")]
    [Parameter(HelpMessage = "RunAsAdministrator.")]
    [switch]$RunAsAdministrator
  )

  # Get default SourceFilePath
  IF ($null -eq $FilePath) {
    $FilePath = Read-Host "Please input path of the file that you want to create a shortcut for"
    IF (($null -eq $FilePath) -or (-not (Test-Path $FilePath))) {
      throw "The file path is required. It must be not null and a valid file path."
    }
  }

  $SourceFile = Get-Item $FilePath
  if($null -eq $SourceFile){
    throw "The source file does not exist."
  }
  Write-Verbose "Source file path: $FilePath"

  # Get default Destination Directory
  IF ( $null -eq $ShortcutDirectory) {
    $ShortcutDirectory = $SourceFile.DirectoryName
  }

  # Get shortcut file name
  if(($null -eq $ShortcutName) -or ("" -eq $ShortcutName)){
    $ShortcutName = $SourceFile.BaseName + ".lnk"
  }

  # Get destination file path
  $ShortcutPath = "$ShortcutDirectory\$ShortcutName"
  Write-Verbose "Shortcut file path: $ShortcutPath"

  Write-Verbose "Script parameters: $ScriptParameters"

  # Create a new shortcut file
  Write-Verbose "Create new shortcut"
  $WshShell = New-Object -comObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
  $Shortcut.TargetPath = "powershell.exe"
  $Shortcut.Arguments = "-command ""& '$FilePath' $ScriptParameters"""
  $Shortcut.Save()

  # Modify the shortcut's access privilege
  if ($RunAsAdministrator) {
    Write-Verbose "Setup shortcut - RunAsAdministrator"
    $bytes = [System.IO.File]::ReadAllBytes("$ShortcutPath")
    $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes("$ShortcutPath", $bytes)
  }

  Write-Verbose "Done"
}