if($null -eq (Get-Command Get-Project -EA SilentlyContinue))
{
    function Get-Project {
        param ($Config, $ProjectID)

        return $Config.Projects | Where-Object { $_.ID -eq $ProjectID } | Select -First  1
    }
}