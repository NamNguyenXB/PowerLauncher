if($null -eq (Get-Command Update-Config -EA SilentlyContinue))
{
    function Update-Config
    {
        param ($Path, $ConnectionString, $Parity4WebApiUri)

        $FolderPath = Split-Path -Path $Path

        Split-Path -Path "$Path" -Leaf -Resolve | ForEach-Object {
            $doc = (Get-Content "$FolderPath\$_") -as [Xml]
            $root = $doc.get_DocumentElement();

            if ($null -ne $root.connectionStrings) {
                $root.connectionStrings.SelectNodes("add") | ForEach-Object {
                    if ($_.name -eq "ConnectionString") {
                        $_.SetAttribute("connectionString", $connectionString);
                        $_.SetAttribute("providerName", "System.Data.SqlClient");
                    }
                }
            }

            $root.appSettings.SelectNodes("add") | ForEach-Object {
                if ($_.key -eq "Parity4WebApiUri") {
                    $_.SetAttribute("value", $Parity4WebApiUri);
                }
            }

            $doc.Save("$FolderPath\$_")
        }
    }
}