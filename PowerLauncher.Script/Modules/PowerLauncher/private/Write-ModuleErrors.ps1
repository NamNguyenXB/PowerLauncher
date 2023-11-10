function Write-ModuleErrors {
  param($ModuleErrors)

  if (($null -ne $ModuleErrors) -and ($ModuleErrors.Count -gt 0)) {
    if ($null -eq $LogLevel) {
      $global:LogLevel = 0;
    }

    # Save the log level.
    $OriginalLevel = $LogLevel;

    $BackgroundColor = 'Black'
    $ForegroundColor = 'Black'
    $Content = ""
    Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

    $BackgroundColor = 'Yellow'
    $ForegroundColor = 'Red'
    $Content = " Errors "
    Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

    $BackgroundColor = 'Red'
    $ForegroundColor = 'White'
    Write-Content ">" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
    $BackgroundColor = 'Red'
    $ForegroundColor = 'Black'
    Write-Content " Begin " -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

    $global:LogLevel = $Loglevel + 1

    foreach ($ErrorKey in $ModuleErrors.Keys) {
      $BackgroundColor = 'Black'
      $ForegroundColor = 'Yellow'
      $Content = "$ErrorKey"
      Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

      $global:LogLevel = $Loglevel + 1

      $ModuleError = $ModuleErrors[$ErrorKey]

      $BackgroundColor = 'Black'
      $ForegroundColor = 'Red'
      $Content = $ModuleError.Exception.Message
      Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor
      $Content = $ModuleError.InvocationInfo.PositionMessage
      Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

      $global:LogLevel = $Loglevel - 1
    }

    $global:LogLevel = $Loglevel - 1

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

    $BackgroundColor = 'Black'
    $ForegroundColor = 'Black'
    $Content = ""
    Write-Content -Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

    # Restore the log level.
    $global:LogLevel = $
  }
}