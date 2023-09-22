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
    [String] $Content
  )
  Write-Output $Content
}