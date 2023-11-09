if ($null -eq (Get-Command Invoke-SqlScript -EA SilentlyContinue)) {
  function Invoke-SqlScript {
    param($Module, $Config)

    $InstallFolder = $Config.InstallFolder
    $SqlServer = $Config.SqlServer
    $DB = $Config.Database
    $ScriptFilePath = $Module.Script

    if (!(Test-Path -Path $ScriptFilePath)) {
      $SQLScriptsFolder = "$InstallFolder/SQLScripts"
      $ScriptFilePath = "$SQLScriptsFolder/$ScriptFilePath"
    }

    Invoke-Sqlcmd -ServerInstance $SqlServer -Database $DB -InputFile $ScriptFilePath
  }
}