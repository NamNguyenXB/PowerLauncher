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
    $Module
  )

  # If no log level, use the default level: 0.
  if ($null -eq $LogLevel) {
    $global:LogLevel = 0;
  }

  # Save the log level.
  $OriginalLevel = $LogLevel;

  $global:LogLevel = $Loglevel + 1

  # Write '>'
  $BackgroundColor = 'Red'
  $ForegroundColor = 'White'
  Write-Content ">" -ForegroundColor White -BackgroundColor Red -NoNewline

  # Write '  End  '
  $Prefix = "  "
  $Content = "End"
  $Postfix = "  "
  $BackgroundColor = 'Red'
  $ForegroundColor = 'Black'
  Write-Content $Prefix -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content $Postfix -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content "" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

  # Restore the log level.
  $global:LogLevel = $OriginalLevel
}