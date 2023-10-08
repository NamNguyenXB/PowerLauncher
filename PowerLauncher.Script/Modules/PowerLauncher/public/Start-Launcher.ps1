<#
.SYNOPSIS
Install PowerLauncher

.PARAMETER ConfigurationPath
Path of the configuration file.

.PARAMETER SetupPath
Path of the Launcher information file.

.PARAMETER ModulesPath
Path of the Launcher information file.

.EXAMPLE

#>
function Start-Launcher {
    param (
        [ValidateScript({ Test-Path $_ })]
        $ConfigurationPath,
        [ValidateScript({ Test-Path $_ })]
        $SetupPath,
        [ValidateScript({ Test-Path $_ })]
        $ModulesPath
    )

    $InstallFolder = $env:PowerLauncher_InstallDir

    # Load Launch.json file
    $SetupLaunchers = Get-Content $SetupPath | ConvertFrom-Json
    $Launchers = Get-Content $ModulesPath | ConvertFrom-Json
    $Config = Get-Content $ConfigurationPath | ConvertFrom-Json

    # Add the InstallFolder to the $Config
    if (-not $Config.InstallFolder) {
        $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
    }

    # Run LauncherHeads
    Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $true

    # Run Launchers
    Invoke-Launchers -l $Launchers -c $Config

    # Run LauncherTails
    Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -h $false

    if (-not $Config.CloseWhenDone) {
        Read-Host -Prompt "Press Enter to exit"
    }
}