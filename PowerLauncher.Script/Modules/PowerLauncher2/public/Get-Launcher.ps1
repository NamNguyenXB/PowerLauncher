function Get-Launcher {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    $LauncherName
  )

  begin {}

  process {
    # Get environment variable
    $SoftwareDirectory = $env:PowerLauncher_InstallDir

    # Initialize Variables
    $Launcher = @{
      Name          = $LauncherName
      Configuration = @{}
      SetupModules  = @()
      Modules       = @()
      Path          = "$SoftwareDirectory\Launchers\$LauncherName"
      State         = "New"
      Error         = @{}
    }

    # Load Launcher configuration
    $Path = "$SoftwareDirectory\configuration.json"
    if (Test-Path $Path -PathType Leaf) {
      try {
        $Launcher.Configuration = (Get-Content $Path | ConvertFrom-Json)
      }
      catch {
        $ErrorMessage = "Cannot parse JSON from file ($Path)"
        $Launcher.Error.Message = $ErrorMessage
        $Launcher.Error.Exception = $_
        $Launcher.State = "Error"
        Write-Error $ErrorMessage
      }
    }

    # Load Setup Modules
    $Path = "$($Launcher.Path)\setup.json"
    if (Test-Path $Path -PathType Leaf) {
      try {
        $Launcher.SetupModules = (Get-Content $Path | ConvertFrom-Json)
      }
      catch {
        $ErrorMessage = "Cannot parse JSON from file ($Path)"
        $Launcher.Error.Message = $ErrorMessage
        $Launcher.Error.Exception = $_
        $Launcher.State = "Error"
        Write-Error $ErrorMessage
      }
    }

    # Load Modules
    $Path = "$($Launcher.Path)\modules.json"
    if (Test-Path $Path -PathType Leaf) {
      try {
        $Launcher.Modules = (Get-Content $Path | ConvertFrom-Json)
      }
      catch {
        $ErrorMessage = "Cannot parse JSON from file ($Path)"
        $Launcher.Error.Message = $ErrorMessage
        $Launcher.Error.Exception = $_
        $Launcher.State = "Error"
        Write-Error $ErrorMessage
      }
    }

    return $Launcher
  }

  end {}
}