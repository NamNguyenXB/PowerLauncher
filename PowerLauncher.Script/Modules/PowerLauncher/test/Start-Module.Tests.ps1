BeforeAll {
  Import-Module $PSScriptRoot\..\PowerLauncher
}

Describe "Start-Module" {
  It 'Does not run when module is null' {
    Start-Module -Module $null -Config $null
  }
}