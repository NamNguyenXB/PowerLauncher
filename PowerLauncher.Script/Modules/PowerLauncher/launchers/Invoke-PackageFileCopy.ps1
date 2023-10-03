if ($null -eq (Get-Command Invoke-PackageFileCopy -EA SilentlyContinue)) {
  function Invoke-PackageFileCopy {
    param (
      $Launcher,
      $Config,
      $Verbose
    )

    if ($Launcher.Run) {
            
      # Source
      $PackageFolder = $Launcher.PackageFolder
      if (!$PackageFolder) {
        $PackageFolder = $Config.InstallFolder
      }
      $SourceFolder = "$PackageFolder/$($Launcher.Source)"

      #Dest
      $Parity4RepoFolder = $Config.RepoFolder
      $DestFolder = "$Parity4RepoFolder/$($Launcher.Dest)"

      #Copy all files from source to dest
      Copy-Item -Path "$SourceFolder\*" -Destination "$DestFolder" -Recurse -Force
    }
  }
}