if ($null -eq (Get-Command Invoke-Flyway -EA SilentlyContinue)) {
  function Invoke-Flyway {
    param ($Module, $Config)

    $Parity4RepoFolder = $Config.RepoFolder
    $SqlServer = $Config.SqlServer
    $DB = $Config.Database

    $UserName = $Module.UserName
    $Password = $Module.Password
    $BaseLineVersion = $Module.BaseLineVersion
    $RepairBeforeMigrate = $Module.RepairBeforeMigrate

    $SavedLocation = Get-Location
    Set-Location -Path "$Parity4RepoFolder\Parity4_CDImageTemplates\Parity4\Tools\flyway"

    if ($RepairBeforeMigrate) {
      .\flyway -url="jdbc:sqlserver://$SqlServer;databaseName=$DB" -user="$UserName" -password="$Password" -baselineVersion="$BaselineVersion" repair
    }

    .\flyway -url="jdbc:sqlserver://$SqlServer;databaseName=$DB" -user="$UserName" -password="$Password" -baselineVersion="$BaselineVersion" migrate

    Set-Location -Path $SavedLocation
  }
}