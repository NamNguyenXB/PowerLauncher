if($null -eq (Get-Command Get-ConnectionString -EA SilentlyContinue))
{

    function Get-ConnectionString {
        param (
            $Config
        )

        $SqlServer = Get-SqlServer $Config
        $DB = Get-Database $Config

        return "Integrated Security=SSPI;Pooling=false;Data Source=$SqlServer;Initial Catalog=$DB"
    }

}