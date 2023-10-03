if($null -eq (Get-Command Get-SqlServer -EA SilentlyContinue))
{
    function Get-SqlServer {
        param ($Config)
        return $Config.SqlServer
    }
}