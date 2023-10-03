if($null -eq (Get-Command Remove-BaseFolder -EA SilentlyContinue))
{
    # Remove Base Folder: <BaseFolder>/<Path> -> <Path>
    function Remove-BaseFolder {
        param ($Path, $BaseFolder)
        $Path = $Path.Replace($BaseFolder, "")
        if($Path[0] -eq "\") {
            $Path = $Path.Remove(0,1)
        }
        $Path
    }
}