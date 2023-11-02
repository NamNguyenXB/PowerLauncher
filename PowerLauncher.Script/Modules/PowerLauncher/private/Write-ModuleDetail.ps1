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

  # Write '> Run Details'
  $global:LogLevel = $LogLevel + 1
  Write-Content ">" -ForegroundColor Black -BackgroundColor Gray -NoNewline
  Write-Content " Run Details " -ForegroundColor Black -BackgroundColor Gray

  # Write Module parameters with the display pattern: '> Name: Value'
  $global:LogLevel = $LogLevel + 1
  $Module.PSObject.Properties | ForEach-Object {
    if (($_.Name -ne "ID") -and ($_.Name -ne "Name") -and ($_.Name -ne "Run") -and ($null -ne ${_}.Value) -and ("" -ne ${_}.Value)) {
      Write-Content ">" -NoNewline
      Write-Content " $(${_}.Name): " -NoNewline
      Write-Content "$(${_}.Value)" -ForegroundColor Yellow
    }
  }

  # Restore the log level.
  $global:LogLevel = $OriginalLevel
}