
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
    [String] $Tag
  )

  # Allow null
  IF ($Content -eq $null) {
    $Content = ""
  }

  IF ($Tag -eq $null) {
    $Tag = ""
  }

  if (($Tag.Length -gt 1) -and ($Content.Length -gt 1)) {
    $Delimiter = " | "
  }
  else {
    $Delimiter = ""
  }

  $Content = $Content + $Delimiter + $Tag
  $Dashes = "o" + "-" * ($Content.Length + 2) + "o"

  Write-Content $Dashes
  Write-Content "| $Content |"
  Write-Content $Dashes
}