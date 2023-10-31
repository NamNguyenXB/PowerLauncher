if ($null -eq (Get-Command Get-ConnectionString -EA SilentlyContinue)) {

  function Get-ConnectionString {
    param (
      $Config
    )

    $SqlServer = $Config.SqlServer
    $DB = $Config.Database

    return "Integrated Security=SSPI;Pooling=false;Data Source=$SqlServer;Initial Catalog=$DB"
  }
}