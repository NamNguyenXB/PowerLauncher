BeforeAll {
  . $PSScriptRoot\..\public\Get-Launcher.ps1
}

Describe 'Get-Launcher' {

  Context 'When configuration file exists'{
    It 'Should load configuration from file' {
      Mock Get-Content { '{"key": "value"}' } -Verifiable
      $launcher = Get-Launcher -LauncherName 'TestLauncher'
      Should -InvokeVerifiable
      $launcher.Configuration.key | Should -Be 'value'
    }
  }

  Context 'When calling Get-Launcher' {
    #Mock Get-Content { $null } -Verifiable

    It 'Should return a launcher object' {
      
      Mock Get-Content { "" } -Verifiable
      #. $PSScriptRoot\..\public\Get-Launcher.ps1
      Get-Launcher -LauncherName 'TestLauncher'
      Should -InvokeVerifiable
      #$launcher.Configuration | Should -Be @{ 'key' = 'value' }
    }

    # It 'Should return a launcher object' {
    #   Mock Get-Content { $null } -Verifiable -ModuleName Microsoft.PowerShell.Management
    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher | Should -Not -BeNullOrEmpty
    #   $launcher.Name | Should -Be 'TestLauncher'
    #   $launcher.State | Should -Be 'New'
    #   $launcher.Path | Should -Be "$env:PowerLauncher_InstallDir\Launchers\TestLauncher"
      
    #   Should -InvokeVerifiable
    #   #$launcher.Configuration | Should -Be @{ 'key' = 'value' }
    # }

    

    # It 'Should handle errors when loading configuration' {
    #   Mock Get-Content { throw 'Invalid JSON' } -ModuleName Microsoft.PowerShell.Management -ParameterFilter { $_ -eq "$env:PowerLauncher_InstallDir\configuration.json" }

    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher.State | Should -Be "Error"
    #   $launcher.Error.Message | Should -Be "Cannot parse JSON from file ($env:PowerLauncher_InstallDir\configuration.json)"
    #   $launcher.Error.Exception | Should -BeOfType System.Management.Automation.RuntimeException
    # }

    # It 'Should load setup modules from file' {
    #   Mock Get-Content { '["Module1", "Module2"]' } -ModuleName Microsoft.PowerShell.Management

    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher.SetupModules | Should -Be @('Module1', 'Module2')
    # }

    # It 'Should handle errors when loading setup modules' {
    #   Mock Get-Content { throw 'Invalid JSON' } -ModuleName Microsoft.PowerShell.Management -ParameterFilter { $_ -eq "$env:PowerLauncher_InstallDir\Launchers\TestLauncher\setup.json" }

    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher.State | Should -Be "Error"
    #   $launcher.Error.Message | Should -Be "Cannot parse JSON from file ($env:PowerLauncher_InstallDir\Launchers\TestLauncher\setup.json)"
    #   $launcher.Error.Exception | Should -BeOfType System.Management.Automation.RuntimeException
    # }

    # It 'Should load modules from file' {
    #   Mock Get-Content { '["ModuleA", "ModuleB"]' } -ModuleName Microsoft.PowerShell.Management

    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher.Modules | Should -Be @('ModuleA', 'ModuleB')
    # }

    # It 'Should handle errors when loading modules' {
    #   Mock Get-Content { throw 'Invalid JSON' } -ModuleName Microsoft.PowerShell.Management -ParameterFilter { $_ -eq "$env:PowerLauncher_InstallDir\Launchers\TestLauncher\modules.json" }

    #   $launcher = Get-Launcher -LauncherName 'TestLauncher'
    #   $launcher.State | Should -Be "Error"
    #   $launcher.Error.Message | Should -Be "Cannot parse JSON from file ($env:PowerLauncher_InstallDir\Launchers\TestLauncher\modules.json)"
    #   $launcher.Error.Exception | Should -BeOfType System.Management.Automation.RuntimeException
    # }
  }
}
