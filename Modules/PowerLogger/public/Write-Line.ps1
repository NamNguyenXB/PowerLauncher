<#
.SYNOPSIS
Write a line.

.PARAMETER LineLength
Length of the line. Defaults to 120

.EXAMPLE
Write-Line

Write-Line -LineLength 10
#>
function Write-Line {
  param(
    [Alias("l")]
    [Parameter(HelpMessage = "Length of the line. Default to 120.")]
    [int16] $LineLength = 120
  )
  $Line = "-" * $LineLength
  Write-Content $Line
}