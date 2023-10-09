if ($null -eq (Get-Command Invoke-SqlScript -EA SilentlyContinue)) {
  function Invoke-SqlScript {
    param($Launcher, $Config, $Verbose)

    if ($Launcher.Run) {
      $InstallFolder = $Config.InstallFolder
      $SqlServer = $Config.SqlServer
      $DB = $Config.Database
      $ScriptFilePath = $Launcher.Script

      if (!(Test-Path -Path $ScriptFilePath)) {
        $SQLScriptsFolder = "$InstallFolder/SQLScripts"
        $ScriptFilePath = "$SQLScriptsFolder/$ScriptFilePath"
      }

      Invoke-Sqlcmd -ServerInstance $SqlServer -Database $DB -InputFile $ScriptFilePath
    }
  }
}