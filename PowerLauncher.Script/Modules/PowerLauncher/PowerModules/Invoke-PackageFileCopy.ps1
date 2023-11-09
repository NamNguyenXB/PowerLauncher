if ($null -eq (Get-Command Invoke-PackageFileCopy -EA SilentlyContinue)) {
  function Invoke-PackageFileCopy {
    param (
      $Module,
      $Config
    )

    # Source
    $PackageFolder = $Module.PackageFolder
    if (!$PackageFolder) {
      $PackageFolder = $Config.InstallFolder
    }
    $SourceFolder = "$PackageFolder\$($Module.Source)"

    #Dest
    $Parity4RepoFolder = $Config.RepoFolder
    $DestFolder = "$Parity4RepoFolder/$($Module.Dest)"

    #Copy all files from source to dest
    Copy-Item -Path "$SourceFolder\*" -Destination "$DestFolder" -Recurse -Force
  }
}