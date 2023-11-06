function Write-ModuleTitle{
  param(
    $Module
  )

   # If no log level, use the default level: 0.
   if ($null -eq $LogLevel) {
    $global:LogLevel = 0;
  }

  # Save the log level.
  $OriginalLevel = $LogLevel;

  $BoderThick = 0

  $Border = " " * $BoderThick
  $Prefix_1 = " Module: "
  $ModuleID = $Module.ID
  $Postfix_1 = " "
  $Delimiter = " "
  $Prefix_2 = "( "
  $ModuleName = $Module.Name
  $Postfix_2 = " )"

  $ModuleLength = $Prefix_1.Length + $ModuleID.Length + $Postfix_1.Length
  $ModuleLength = $ModuleLength + $Delimiter.Length
  $ModuleLength = $ModuleLength + $Prefix_2.Length + $ModuleName.Length + $Postfix_2.Length
  $ModuleLength = $ModuleLength + $BoderThick * 2

  # Write a blue line
  Write-Line -Size $ModuleLength -Content " " -Color Black

  # Write Content

  # Left Boder
  $BackgroundColor = 'Blue'
  $ForegroundColor = 'White'
  Write-Content -Content $Border -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline

  # Module ID: <Prefix_1><ModuleID><Postfix_1>
  $BackgroundColor = 'Yellow'
  $ForegroundColor = 'Black'
  Write-Content -Content "$Prefix_1" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content -Content "$ModuleID " -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content -Content "$Postfix_1" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline

  # Delimiter
  $BackgroundColor = 'Black'
  $ForegroundColor = 'White'
  Write-Content -Content "$Delimiter" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline

  # Module name: <Prefix_2><ModuleName><Postfix_2>
  $BackgroundColor = 'Black'
  $ForegroundColor = 'White'
  Write-Content -Content "$Prefix_2" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content -Content "$ModuleName" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
  Write-Content -Content "$Postfix_2" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline

  # Right Boder
  $BackgroundColor = 'Blue'
  $ForegroundColor = 'White'
  Write-Content -Content $Border -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor

  # Write a blue line
  #Write-Line -Size $LineLength -Content " " -Color Blue

  # Restore the log level.
  $global:LogLevel = $OriginalLevel
}