if($null -eq (Get-Command Get-Database -EA SilentlyContinue))
{

    function Get-Database {
        param ($Config)
        return $Config.Database
    }

}