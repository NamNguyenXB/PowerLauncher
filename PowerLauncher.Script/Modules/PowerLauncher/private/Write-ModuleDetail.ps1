function Write-ModuleDetail {
  param(
    $Module
  )

  # If no log level, use the default level: 0.
  if ($null -eq $LogLevel) {
    $global:LogLevel = 0;
  }

  # Save the log level.
  $OriginalLevel = $LogLevel;

  $global:LogLevel = $LogLevel + 1

  # Write Header
  $Prefix = "> "
  $Content = "Run Details"
  $Postfix = " "
  $BackgroundColor = 'Black'
  $ForegroundColor = 'White'
  Write-Content $Prefix -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  $BackgroundColor = 'Black'
  $ForegroundColor = 'White'
  Write-Content $Content -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content $Postfix -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content "" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

  # Write Module parameters with the display pattern: '> Name: Value'
  $global:LogLevel = $LogLevel + 1
  $Module.PSObject.Properties | ForEach-Object {
    if ((
          $_.Name -ne "ID"
        ) -and (
          $_.Name -ne "Name"
        ) -and (
          $_.Name -ne "Run"
        ) -and (
          $null -ne ${_}.Value
        ) -and (
          "" -ne ${_}.Value
        )) {
      $Prefix_1 = "> "
      $Content_1 = ${_}.Name
      $Postfix_1 = ""
      $Delimiter = ": "
      $Prefix_2 = ""
      $Content_2 = ${_}.Value
      $Postfix_2 = ""
      $BackgroundColor = 'Black'
      $ForegroundColor = 'White'
      Write-Content $Prefix_1 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content $Content_1 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content $Postfix_1 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content $Delimiter -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      $BackgroundColor = 'Black'
      $ForegroundColor = 'Yellow'
      Write-Content $Prefix_2 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content $Content_2 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content $Postfix_2 -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
      Write-Content "" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor
    }
  }

  # Restore the log level.
  $global:LogLevel = $OriginalLevel
}