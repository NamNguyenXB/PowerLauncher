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

  if (Confirm-ModuleRun -Module $Module) {

    # If no log level, use the default level: 0.
    if ($null -eq $LogLevel) {
      $global:LogLevel = 0;
    }

    # Save the log level.
    $OriginalLevel = $LogLevel;
  
    # Print title
    Write-ModuleTitle -Module $Module

    # Write Module Details.
    Write-ModuleDetail -Module $Module

    $global:LogLevel = $LogLevel + 1
    Write-Content ">" -Level 1 -ForegroundColor White -BackgroundColor Green -NoNewline
    Write-Content " Begin " -ForegroundColor Black -BackgroundColor Green

    # Restore the log level.
    $global:LogLevel = $OriginalLevel
  }
}