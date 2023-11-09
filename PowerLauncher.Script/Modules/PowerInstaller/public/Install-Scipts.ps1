function Install-Scripts{
  param(
    $SourceDirectory,
    $InstallDirectory
  )

  IF ($InstallDirectory -ne $SourceDirectory) {
    Copy-Item "$SourceDirectory\Templates" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
    Copy-Item "$SourceDirectory\Tools" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
    Copy-Item "$SourceDirectory\Icons" -Destination "$InstallDirectory" -Recurse -ErrorAction SilentlyContinue
  }

  # Install configuration
  if (-not(Test-Path "$InstallDirectory\configuration.json")) {
    Write-Output "{}" > "$InstallDirectory\configuration.json"
  }
}