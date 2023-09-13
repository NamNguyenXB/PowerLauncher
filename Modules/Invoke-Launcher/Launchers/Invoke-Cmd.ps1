if ($null -eq (Get-Command Invoke-Cmd -EA SilentlyContinue)) {
  function Invoke-Cmd {
    param($Launcher, $Config)

    if ($Launcher.Run) {
      $Cmd = $Launcher.Cmd
      $Arguments = $Launcher.Arguments
      $Command = "$Cmd $Arguments"
      Invoke-Expression $Command
    }
  }
}