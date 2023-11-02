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

  $BoderThick = 1

  $Border = " " * $BoderThick
  $Prefix = " "
  $ModuleID = $Module.ID
  $Delimiter = ": "
  $ModuleName = $Module.Name
  $Postfix = " "
  
  $ModuleLength = ($Prefix.Length + $ModuleID.Length + $Delimiter.Length + $ModuleName.Length + $Postfix.Length  + $BoderThick * 2)

  # Write a blue line
  Write-Line -Size $ModuleLength -Content " " -Color Blue

  # Write Content
  Write-Content -Content $Border -BackgroundColor Blue -NoNewline
  Write-Content -Content "$Prefix" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content -Content "$ModuleID" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content -Content "$Delimiter" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content -Content "$ModuleName" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content -Content "$Postfix" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content -Content $Border -BackgroundColor Blue

  # Write a blue line
  #Write-Line -Size $LineLength -Content " " -Color Blue

  # Restore the log level.
  $global:LogLevel = $OriginalLevel
}