function Write-LauncherError{
  param(
    [Parameter()]
    $LauncherError
  )

  Write-Error $LauncherError
}