Add-Type -Assembly 'System.Drawing'

<#
.SYNOPSIS
  Renders an image to the console
.DESCRIPTION
  Out-ConsolePicture will take an image file and convert it to a text string.
  Colors will be "encoded" using ANSI escape strings.
  The final result will be output in the shell.
  By default images will be reformatted to the size of the current shell
  , though this behaviour can be suppressed with the -DoNotResize switch.
  
  ISE users, take note:
    ISE does not report a window width, and scaling fails as a result.
    I don't think there is anything I can do about that, so either use the -DoNotResize switch, or don't use ISE.

  This function was refered to https://www.powershellgallery.com/packages/OutConsolePicture/1.6

.PARAMETER Path
  One or more paths to the image(s) to be rendered to the console.
.PARAMETER Url
  One or more Urls for the image(s) to be rendered to the console.
.PARAMETER InputObject
  A Bitmap object that will be rendered to the console.
.PARAMETER DoNotResize
  By default, images will be resized to have their width match the current console width.
  Setting this switch disables that behaviour.
.PARAMETER Width
  Renders the image at this specific width. Use of the width parameter overrides DoNotResize.

.EXAMPLE
  Out-ConsolePicture ".\someimage.jpg"
  Renders the image to console

.EXAMPLE
  Out-ConsolePicture -Url "http://somewhere.com/image.jpg"
  Renders the image to console

.EXAMPLE
  $image = New-Object System.Drawing.Bitmap -ArgumentList "C:\myimages\image.png"
  $image | Write-Picture
  Creates a new Bitmap object from a file on disk renders it to the console

.INPUTS
  One or more System.Drawing.Bitmap objects
.OUTPUTS
  Gloriously coloured console output
#>
function Write-Picture {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, ParameterSetName = "FromPath", Position = 0)]
    [ValidateNotNullOrEmpty()][string[]]
    $Path,

    [Parameter(Mandatory = $true, ParameterSetName = "FromWeb")]
    [System.Uri[]]$Url,

    [Parameter(Mandatory = $true, ParameterSetName = "FromPipeline", ValueFromPipeline = $true)]
    [System.Drawing.Bitmap[]]$InputObject,

    [Parameter()]
    [int]$Width,

    [Parameter()]
    [switch]$DoNotResize
  )

  begin {
    if ($PSCmdlet.ParameterSetName -eq "FromPath") {
      foreach ($file in $Path) {
        try {
          $image = New-Object System.Drawing.Bitmap -ArgumentList "$(Resolve-Path $file)"
          $InputObject += $image
        }
        catch {
          Write-Error "An error occurred while loading image. Supported formats are BMP, GIF, EXIF, JPG, PNG and TIFF."
        }
      }
    }

    if ($PSCmdlet.ParameterSetName -eq "FromWeb") {
      foreach ($uri in $Url) {
        try {
          $data = (Invoke-WebRequest $uri).RawContentStream
        }
        catch [Microsoft.PowerShell.Commands.HttpResponseException] {
          if ($_.Exception.Response.statuscode.value__ -eq 302) {
            $actual_location = $_.Exception.Response.Headers.Location.AbsoluteUri
            $data = (Invoke-WebRequest $actual_location).RawContentStream
          }
          else {
            throw $_
          }
        }

        try {
          $image = New-Object System.Drawing.Bitmap -ArgumentList $data
          $InputObject += $image
        }
        catch {
          Write-Error "An error occurred while loading image. Supported formats are BMP, GIF, EXIF, JPG, PNG and TIFF."
        }
      }
    }

    if ($Host.Name -eq "Windows PowerShell ISE Host") {
      # ISE neither supports ANSI, nor reports back a width for resizing.
      Write-Warning "ISE does not support ANSI colors. No images for you. Sorry! :("
      Break
    }
  }

  process {
    $InputObject | ForEach-Object {
      if ($_ -is [System.Drawing.Bitmap]) {
        $image = $_
        # Resize image to console width or width parameter
        if ($width -or (($image.Width -gt $host.UI.RawUI.WindowSize.Width) -and -not $DoNotResize)) {
          if ($width) {
            $new_width = $width
          }
          else {
            $new_width = $host.UI.RawUI.WindowSize.Width
          }
          $new_height = $image.Height / ($image.Width / $new_width)
          $resized_image = New-Object System.Drawing.Bitmap -ArgumentList $image, $new_width, $new_height
          $image.Dispose()
          $image = $resized_image
        }

        # Build color string that will be outputed to the console.
        $color_string = New-Object System.Text.StringBuilder
        $BackgroundColor = [System.Drawing.Color]::FromName($Host.UI.RawUI.BackgroundColor)
        for ($y = 1; $y -lt $image.Height; $y+=2) {
          [void]$color_string.append("`n")
          for ($x = 0; $x -lt $image.Width; $x++) {
            if (($y + 2) -gt $image.Height) {
              # We are now on the last row. The bottom half of it in images with uneven pixel height
              # should just be coloured like the background of the console.
              $pixel = Get-PixelText $image.GetPixel($x, $y) $BackgroundColor
              [void]$color_string.Append($pixel)
            }
            else {
              $pixel = Get-PixelText $image.GetPixel($x, $y) $image.GetPixel($x, $y + 1)
              [void]$color_string.Append($pixel)
            }
          }
        }
        $color_string.ToString()
        $image.Dispose()
      }
    }
  }

  end {
  }
}