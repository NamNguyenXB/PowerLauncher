if ($null -eq (Get-Command Invoke-WebConfig -EA SilentlyContinue)) {
  function Invoke-WebConfig {
    param ($Module, $Config)

    $Projects = $Config.Projects
    $Parity4RepoFolder = $Config.RepoFolder
    $Parity4WebApiUri = $Config.Parity4WebApiUrl
    $ConnectionString = Get-ConnectionString $Config

    $Projects | ForEach-Object {
      $Project = $_

      $ProjectFolder = $Project.ProjectFolder
      $WebconfigFiles = "$ProjectFolder\web*.config"

      $WebconfigFiles | ForEach-Object {
        Update-Config -Path "$Parity4RepoFolder\$_" -ConnectionString $ConnectionString -Parity4WebApiUri $Parity4WebApiUri
      }
    }
  }
}