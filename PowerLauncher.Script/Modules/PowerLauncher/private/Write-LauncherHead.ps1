<#
.SYNOPSIS
Write information (Head) of a launcher.

.PARAMETER Launcher
Launcher to display.

.EXAMPLE
Write-LauncherHead -Launcher $Launcher
#>
function Write-LauncherHead {
  param (
    [Alias("l")]
    [Parameter(HelpMessage = "Launcher to display.")]
    $Launcher
  )
  #Write-Box -Content $Launcher.Name -Tag "Begin" -ForegroundColor Black -BackgroundColor Yellow

  if($Launcher.Run){
    $Spaces = " " * 80
    Write-Content $Spaces -ForegroundColor White -BackgroundColor Blue
    $Header = " $($Launcher.Name) "
    $Spaces = " " * (80 - $Header.Length)
    Write-Content " " -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content "$Header" -ForegroundColor Black -BackgroundColor Yellow
    #Write-Content $Spaces -ForegroundColor White -BackgroundColor Blue
    Write-Content " " -ForegroundColor White -BackgroundColor Blue
    Write-Content ">" -Level 1 -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content " Run Details " -ForegroundColor Black -BackgroundColor Gray
    $Launcher.PSObject.Properties | ForEach-Object {
      if ((($_.Name) -ne "Name") -and (($_.Name) -ne "Run")) {
        if(($null -ne ${_}.Value) -and ("" -ne ${_}.Value)){
          Write-Content " " -ForegroundColor White -BackgroundColor Blue -NoNewline
          Write-Content "" -Level 2 -NoNewline
          Write-Content "- $(${_}.Name): " -NoNewline
          Write-Content "$(${_}.Value)" -ForegroundColor Yellow
        }
      }
    }
    Write-Content " " -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content ""
    Write-Content " " -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content ">" -Level 1 -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content " Start " -ForegroundColor Black -BackgroundColor Green
  }
}