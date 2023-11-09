if ($null -eq (Get-Command Invoke-VSPublish -EA SilentlyContinue)) {
  function Invoke-VSPublish {
    param (
      $Module,
      $Config
    )

    $Parity4RepoFolder = $Config.RepoFolder
    $InstallFolder = $Config.InstallFolder

    $ProjectID = $Module.ProjectID
    $PublishUrl = $Module.PublishUrl
    $CmdOption = "/k"

    $LogFolder = "$InstallFolder/Logs"
    $LogFile = $ProjectID + "inf.log"
    $ErrorLogFile = $ProjectID + "err.log"


    $Project = Get-Project $Config $ProjectID
    $MsBuildPath = Get-LatestMsBuildPath

    $ProjectFolder = $Project.ProjectFolder
    $VSProjectFile = $Project.VSProjectFile
    $ProjectFile = "$ProjectFolder\$VSProjectFile"
    $ProjectFilePath = "$Parity4RepoFolder\$ProjectFile"

    $MsBuildParameters = "/p:DeployOnBuild=True"
    $MsBuildParameters += " /p:DeployDefaultTarget=WebPublish"
    $MsBuildParameters += " /p:WebPublishMethod=FileSystem"
    $MsBuildParameters += " /p:DeleteExistingFiles=True"
    $MsBuildParameters += " /p:Configuration=Release"
    $MsBuildParameters += " /p:publishUrl=""$PublishUrl"""
    $MsBuildParameters += " /fileLoggerParameters:LogFile=""$LogFolder\$LogFile""$verbosityLevel"
    $MsBuildParameters += " /fileLoggerParameters1:LogFile=""$LogFolder\$ErrorLogFile"";errorsonly"

    $CmdArgumentsToRunMsBuild = "$CmdOption "" ""$MSBuildPath"" ""$ProjectFilePath"" $MsBuildParameters"

    Start-Process cmd.exe -ArgumentList $CmdArgumentsToRunMsBuild -WindowStyle "Maximized" -PassThru
    $ProcessId = $Process.Id
  }
}