function Install-PSModules {
  param(
    $SourceDirectory,
    $PSModulePath
  )

  # Get Modules Directory.
  $ModulesDirectory = "$SourceDirectory\Modules"

  # Verify Modules Directory exists.
  if (-not (Test-Path "$ModulesDirectory")) {
    throw "'Modules' folder was not found."
  }

  # Get Modulle list
  $ModuleList = @("PowerInstaller", "PowerLauncher", "PowerLogger")

  # Validate Modules
  $ModuleList | ForEach-Object {
    if (-not (Test-Path "$ModulesDirectory\$_\$_.psm1")) {
      throw "Module '$_' was not found."
    }
  }

  # Install modules.
  $ModuleList | ForEach-Object {

    # Clean Module Folder before starting copy
    if (Test-Path "$PSModulePath\$_") {
      Remove-Item "$PSModulePath\$_\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Copy source.
    Copy-Item -Path "$ModulesDirectory\$_" -Destination "$PSModulePath" -Recurse -Force -ErrorAction SilentlyContinue
  }
}