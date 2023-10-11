function Write-Title{
  param(
    [String]$Content
  )

  $LineLength = ($Content.Length + 4)

  Write-Line -Size $LineLength -Content " " -Color Blue

  Write-Content " " -BackgroundColor Blue -ForegroundColor White -NoNewline
  Write-Content " $Content " -BackgroundColor Yellow -ForegroundColor Black -NoNewline
  Write-Content " " -BackgroundColor Blue -ForegroundColor White

  Write-Line -Size $LineLength -Content " " -Color Blue
}