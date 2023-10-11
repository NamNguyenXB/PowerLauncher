<#
.SYNOPSIS
Write information (Tail) of a launcher.

.PARAMETER Launcher
Launcher to display.

.EXAMPLE
Write-LauncherTail -Launcher $Launcher
#>
function Write-ModuleTail {
  param (
    [Alias("l")]
    [Parameter(HelpMessage = "Launcher to display.")]
    $Launcher
  )
  Write-Content " " -ForegroundColor White -BackgroundColor Blue
  Write-Content " " -ForegroundColor White -BackgroundColor Blue -NoNewline
  Write-Content ">" -Level 1 -ForegroundColor White -BackgroundColor Blue -NoNewline
  Write-Content " Done  " -ForegroundColor Black -BackgroundColor Green
  Write-Content ""
}