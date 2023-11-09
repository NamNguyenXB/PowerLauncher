if ($null -eq (Get-Command Get-ProjectFilePath -EA SilentlyContinue)) {
  function Get-ProjectFilePath {
    param ($Config, $ProjectID)

    # Get Project in the config with the project ID.
    $Project = $Config.Projects | Where-Object { $_.ID -eq $ProjectID } | Select-Object -First 1

    # Get Project File path if found.
    if($null -ne $Project){
      return "$($Config.RepoFolder)\$($Project.ProjectFolder)\$($Project.VSProjectFile)"
    }

    return ""
  }
}