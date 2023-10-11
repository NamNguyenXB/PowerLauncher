function Get-DatabaseList {
    param(
        $Instance
    )

    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
    $s = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $Instance
    $dbs = $s.Databases | ForEach-Object { Write-Output $_.Name }
    return $dbs
}