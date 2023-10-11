<#
.SYNOPSIS
Write information (Head) of a launcher.

.PARAMETER Launcher
Launcher to display.

.EXAMPLE
Write-LauncherHead -Launcher $Module
#>
function Write-ModuleHead {
  param (
    [Alias("m")]
    [Parameter(HelpMessage = "Module to display.")]
    $Module
  )

  if(Confirm-ModuleRun -Module $Module){

    # Print title
    Write-Title $($Module.Name)

    Write-Content " " -ForegroundColor White -BackgroundColor Blue
    Write-Content ">" -Level 1 -ForegroundColor White -BackgroundColor Blue -NoNewline
    Write-Content " Run Details " -ForegroundColor Black -BackgroundColor Gray
    $Module.PSObject.Properties | ForEach-Object {
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