if ($null -eq (Get-Command Invoke-Cmd -EA SilentlyContinue)) {
  function Invoke-Cmd {
    param($Module, $Config)

    Invoke-Expression "$($Module.Cmd) $($Module.Arguments)"
  }
}