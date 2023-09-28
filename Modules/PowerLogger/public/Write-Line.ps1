<#
.SYNOPSIS
Write a line.

.PARAMETER LineLength
Length of the line. Defaults to 120.

.PARAMETER Character
Character to draw the line. Default to '-'.

.EXAMPLE
Write-Line

Write-Line -LineLength 10
#>
function Write-Line {
  param(
    [Alias("l")]
    [Parameter(HelpMessage = "Length of the line. Default to 120.")]
    [int16] $LineLength = 120,
    [Alias("c")]
    [Parameter(HelpMessage = "Character to draw the line. Default to '-'.")]
    $Character = "-"
  )
  if(($null -eq $Character) -or ($Character.Length -lt 1)){
    $Character = "-"
  }

  if($Character.Length -gt 1){
    $Character = $Character[0]
  }

  $Line = $Character * $LineLength
  Write-Content $Line
}