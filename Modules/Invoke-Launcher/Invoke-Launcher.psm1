if (!$PSScriptRoot) {
  $PSScriptRoot = $MyInovocation.PSScriptRoot
}

if (!$PSScriptRoot) {
  $PSScriptRoot = Split-Path $MyInovocation.MyCommand.Path
}

Get-Item "$PsScriptRoot\Scripts\*.ps1" | ForEach-Object {
  . "$($_.FullName)"
}

Get-Item "$PsScriptRoot\Launchers\*.ps1" | ForEach-Object {
  . "$($_.FullName)"
}

if ($null -eq (Get-Command Run-Launcher -EA SilentlyContinue)) {
  function Invoke-Launcher {
    param($Launcher, $Config, $Verbose)
    if ($Launcher.Run) {
      if ($Verbose = 1) {
        Write-LauncherHead($Launcher)
      }

      $Type = $Launcher.Type
      $FunctionName = "Invoke-" + $Type

      if ($null -ne (Get-Command "$FunctionName" -EA SilentlyContinue)) {
        &"$FunctionName" $Launcher $Config $Verbose
      }
      else {
        Write-Output "|  Cannot run! Type $Type is not supported."
      }

      if ($Verbose = 1) {
        Write-LauncherTail($Launcher)
      }
    }
  }
}

#Export-ModuleMember -Function @(
#    'Invoke-Launcher',
#    'Write-Begin',
#    'Write-End'
#)