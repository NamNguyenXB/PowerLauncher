<#
.SYNOPSIS
Selected Write function of this module.

.PARAMETER Content
Content to display.

.EXAMPLE
Write-Content -Content "Content"
#>
function Write-Content {
  param(
    [Alias("c")]
    [Parameter(HelpMessage = "Content to display.")]
    [String] $Content,
    [Parameter(HelpMessage = "Prefix.")]
    [Alias("p")]
    [String] $Prefix = "",
    [Alias("s")]
    $TabSize = 2,
    [Alias("l")]
    $Level = 0,
    [switch]$NoNewline = $null,
    $Separator = $null,
    $ForegroundColor = $null,
    $BackgroundColor = $null
  )
  $Spaces = " " * ($TabSize * $Level)
  if (($null -ne $Prefix) -and ("" -ne $Prefix)) {
    $Prefix += " "
  }
  $Content = $Prefix + $Spaces + $Content

  $params = ""
  if ($null -ne $Separator) {
    $params = "$params -Separator $Separator"
  }
  if ($null -ne $ForegroundColor) {
    $params = "$params -ForegroundColor $ForegroundColor"
  }
  if ($null -ne $BackgroundColor) {
    $params = "$params -BackgroundColor $BackgroundColor"
  }
  if ($True -eq $NoNewline) {
    $params = "$params -NoNewLine"
  }

  Invoke-Expression ("Write-Host '$Content' $params")
}