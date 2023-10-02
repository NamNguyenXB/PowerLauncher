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
    $Level = 0
  )
  $Spaces = " " * ($TabSize * $Level + 1)
  $Content = $Prefix + $Spaces + $Content
  Write-Output $Content
}