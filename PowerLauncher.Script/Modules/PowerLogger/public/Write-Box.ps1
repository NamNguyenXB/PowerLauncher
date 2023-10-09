
<#
.SYNOPSIS
Write Content in a box.

.PARAMETER Content
Content to display.

.EXAMPLE
Write-Box -Content "Content"
o---------o
| Content |
o---------o

Write-Box -Content "Content" -Tag "Tag"
o---------------o
| Content | Tag |
o---------------o

Write-Box
o--o
|  |
o--o
#>
function Write-Box {
  param(
    [Alias("c")]
    [Parameter(HelpMessage = "Content to display.")]
    [String] $Content,
    [Alias("t")]
    [Parameter(HelpMessage = "Content Tag")]
    [String] $Tag,
    $ForegroundColor = $null,
    $BackgroundColor = $null,
    $TagForegroundColor = $null,
    $TagBackgroundColor = $null
  )

  # Allow null
  IF ($Content -eq $null) {
    $Content = ""
  }

  IF ($Tag -eq $null) {
    $Tag = ""
  }

  if (($Tag.Length -gt 1) -and ($Content.Length -gt 1)) {
    $Tail = " | " + $Tag
  }
  else {
    $Tail = ""
  }

  $Dashes = "o" + "-" * ($Content.Length + 2 + $Tail.Length) + "o"

  Write-Content $Dashes
  Write-Content "| " -NoNewline
  Write-Content "$Content" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
  Write-Content "$Tail |" -ForegroundColor $TagForegroundColor -BackgroundColor $TagBackgroundColor
  Write-Content $Dashes
}
