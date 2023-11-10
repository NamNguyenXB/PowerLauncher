if ($null -eq (Get-Command Invoke-MSBuild -EA SilentlyContinue)) {
  function Invoke-MSBuild {
    param ($Module, $Config)

    # Get MSBuild path.
    $MsBuildPath = Get-LatestMsBuildPath

    # Load configurations
    $ProjectID = $Module.ProjectID
    $Configuration = $Module.Configuration
    $InstallFolder = $Config.InstallFolder
    $CmdOption = "/k"

    # Get Project file path.
    $ProjectFilePath = Get-ProjectFilePath -Config $Config -ProjectID $ProjectID

    # Get Log File paths.
    $BuildInfoFilePath = "$InstallFolder\Logs\MSBuild_$($ProjectID)_info.log"
    $BuildErrorFilePath = "$InstallFolder\Logs\MSBuild_$($ProjectID)_error.log"

    # Build parameters
    $MsBuildParameters = "/p:Configuration=$Configuration"
    $MsBuildParameters += " /fileLoggerParameters:LogFile=""$BuildInfoFilePath""$verbosityLevel"
    $MsBuildParameters += " /fileLoggerParameters1:LogFile=""$BuildErrorFilePath"";errorsonly"

    $CmdArgumentsToRunMsBuild = "$CmdOption "" ""$MSBuildPath"" ""$ProjectFilePath"" $MsBuildParameters"

    #Start-Process cmd.exe -ArgumentList $CmdArgumentsToRunMsBuild -WindowStyle "Maximized" -PassThru

    Invoke-Expression "$MsBuildPath $ProjectFilePath $MsBuildParameters"
  }
}