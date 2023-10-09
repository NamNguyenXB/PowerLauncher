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
        [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
        $ConfigurationPath = $null,
        [ValidateScript({ ($_ -eq $null) -or (Test-Path $_) })]
        $SetupPath = $null,
        [ValidateScript({ Test-Path $_ })]
        $ModulesPath
    )

    $InstallFolder = $env:PowerLauncher_InstallDir

    # Load json files
    if ($null -ne $SetupPath) {
        $SetupLaunchers = Get-Content $SetupPath | ConvertFrom-Json
    }
    
    if ( $null -ne $ConfigurationPath) {
        $Config = Get-Content $ConfigurationPath | ConvertFrom-Json
    }
    else {
        $Config = @{}
    }
    
    $Launchers = Get-Content $ModulesPath | ConvertFrom-Json

    # Add the InstallFolder to the $Config
    if (-not $Config.InstallFolder) {
        $Config | Add-Member -NotePropertyName InstallFolder -NotePropertyValue $InstallFolder
    }

    # Run LauncherHeads
    Invoke-SetupLaunchers -l $SetupLaunchers -c $Config -Head

    # Run Launchers
    Invoke-Launchers -l $Launchers -c $Config

    # Run LauncherTails
    Invoke-SetupLaunchers -l $SetupLaunchers -c $Config

    if (-not $Config.CloseWhenDone) {
        Read-Host -Prompt "Press Enter to exit"
    }
}