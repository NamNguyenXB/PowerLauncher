if ($null -eq (Get-Command Invoke-LinkERP -EA SilentlyContinue)) {
  function Invoke-LinkERP {
    param($Launcher, $Config, $Verbose)

    if ($Launcher.Run) {
      $Uri = $Launcher.Uri
      $UserId = $Launcher.UserId
      $TriggerId = $Launcher.TriggerId
      $ProcessId = $Launcher.ProcessId

      WHILE(($null -eq $Uri) -or ("" -eq $Uri)){
        $Uri = Read-Host "Please input Uri:"
        #$Uri = "http://localhost/Parity4LinkERPWebAPI/api/INApplication/NetSuite/v2/In"
      }

      IF(($null -eq $UserId) -or ("" -eq $UserId)){
        $UserId = "Developer"
      }

      IF(($null -eq $TriggerId) -or ("" -eq $TriggerId)){
        $TriggerId = "RunINApplicationProcess"
      }

      WHILE(($null -eq $ProcessId) -or ("" -eq $ProcessId)){
        $ProcessId = Read-Host "Please input ProcessID:"
      }

      $Body = @{"UserID"="$UserId";"TriggerID"="$TriggerId";"ProcessID"="$ProcessId"}
      $Result = Invoke-RestMethod -Uri $Uri -Body $Body -Method Post

      Write-Output $Result
    }
  }
}
