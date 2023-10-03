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
        $NoNewline,
        $Separator,
        $ForegroundColor,
        $BackgroundColor
    )
    $Spaces = " " * ($TabSize * $Level + 1)
    $Content = $Prefix + $Spaces + $Content
  
    $params = ""
    if ($null -ne $NoNewline) {
        $params = $params + " -NoNewLine"
    }
    if ($null -ne $Separator) {
        $params = $params + " -Separator $Separator"
    }
    if ($null -ne $ForegroundColor) {
        $params = $params + " -ForegroundColor $ForegroundColor"
    }
    if ($null -ne $BackgroundColor) {
        $params = $params + " -BackgroundColor $BackgroundColor"
    }
  
    Write-Host $Content $params
}