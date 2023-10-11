<#
.SYNOPSIS
Write a line.

.PARAMETER LineLength
Length of the line. Defaults to 120.

.PARAMETER Content
Content to draw the line. Default to '-'.

.EXAMPLE
Write-Line

Write-Line -LineLength 10
#>
function Write-Line {
  param(
    [Parameter(HelpMessage = "Length of the line. Default to 120.")]
    [int16] $Size = 120,
    [Parameter(HelpMessage = "Content to draw the line. Default to '-'.")]
    $Content = "-",
    $Color,
    [Switch]$NoNewline
  )
  if (($null -eq $Content) -or ($Content.Length -lt 1)) {
    $Content = "-"
  }

  if ($Content.Length -gt 1) {
    $Content = $Content[0]
  }

  $Line = $Content * $LineLength
  if ($NoNewline.IsPresent) {
    Write-Content $Line -BackgroundColor $Color -NoNewline
  }
  else {
    Write-Content $Line -BackgroundColor $Color
  }
}