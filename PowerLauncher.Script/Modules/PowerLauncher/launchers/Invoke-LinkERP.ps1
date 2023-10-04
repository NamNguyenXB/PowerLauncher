if ($null -eq (Get-Command Invoke-LinkERP -EA SilentlyContinue)) {
  function Invoke-LinkERP {
    param($Launcher, $Config, $Verbose)

    if ($Launcher.Run) {
      $Uri = $Launcher.Uri
      $UserId = $Launcher.UserId
      $TriggerId = $Launcher.TriggerId
      $ApplicationId = $Launcher.ApplicationId
      $ProcessId = $Launcher.ProcessId
      $OutputPath = $Launcher.OutputPath

      IF(($null -eq $Uri) -or ("" -eq $Uri)){
        throw "Uri is required."
      }

      IF(($null -eq $UserId) -or ("" -eq $UserId)){
        $UserId = "PowerLauncher"
      }

      IF(($null -eq $TriggerId) -or ("" -eq $TriggerId)){
        $TriggerId = "RunINApplicationProcess"
      }

      IF(($null -eq $ProcessId) -or ("" -eq $ProcessId)){
        throw "ProcessId is required."
      }

      # Activate Process
      Write-Content 'Activate the Process' -ForegroundColor "Yellow"
      $StringArray = "ApplicationID='$ApplicationId'", "ProcessID='$ProcessId'", "TriggerID='$TriggerId'"
      $Query = "
        -- SKs
        DECLARE
            @INApplicationSK                    UNIQUEIDENTIFIER
          , @INApplicationProcessSK             UNIQUEIDENTIFIER
          , @INApplicationProcessTriggerSK      UNIQUEIDENTIFIER
        
        -- SELECT INApplicationSK & INApplicationProcessSK
        SELECT
            @INApplicationSK                    = INApplication.INApplicationSK
          , @INApplicationProcessSK             = INApplicationProcess.INApplicationProcessSK
          , @INApplicationProcessTriggerSK      = INApplicationProcessTrigger.INApplicationProcessTriggerSK
          FROM INApplicationProcess
          INNER JOIN INApplication ON INApplication.INApplicationSK = INApplicationProcess.INApplicationSK
          INNER JOIN INApplicationProcessTrigger ON INApplicationProcessTrigger.INApplicationProcessSK = INApplicationProcess.INApplicationProcessSK
          INNER JOIN INTrigger ON INTrigger.INTriggerSK = INApplicationProcessTrigger.INTriggerSK
          WHERE
          (
                ApplicationID = `$(ApplicationID)
            AND ProcessID = `$(ProcessID)
            AND TriggerID = `$(TriggerID)
          )
        
        -- Activate Application
        UPDATE dbo.INApplication SET
            IsActive = 1
          WHERE INApplicationSK = @INApplicationSK
        
        -- Activate Process
        UPDATE dbo.INApplicationProcess SET
            IsActive = 1
          WHERE INApplicationProcessSK = @INApplicationProcessSK
        
        -- Activate Trigger
        UPDATE dbo.INApplicationProcessTrigger SET
            IsActive = 1
          WHERE INApplicationProcessTriggerSK = @INApplicationProcessTriggerSK"
      Invoke-Sqlcmd -ServerInstance “SONG-NAMNGUYEN" -Database 'PDB_Parity4' -Query $Query -Variable $StringArray

      Write-Content -c 'Call API' -ForegroundColor "Yellow"
      $Body = @{"UserID"="$UserId";"TriggerID"="$TriggerId";"ProcessID"="$ProcessId"}
      $Result = Invoke-RestMethod -Uri $Uri -Body $Body -Method Post
      if($null -ne $OutputPath){
        $Result | Out-File -FilePath $OutputPath
      }

      $ErrorCount = $Result.ErrorCount
      IF($ErrorCount -eq 0){
        $Color = "Yellow"
      } else{
        $Color = "Red"
      }
      
      Write-Content -c "Errors: ${Result}.Errors" -ForegroundColor $Color
      Write-Content -c "ErrorCount: " + $Result.ErrorCount -ForegroundColor $Color

      $RunID = $Result.RunID
      $StringArray = @("RunID='$RunID'")
      $Query = "
        SELECT
            [ID - RunID - TransactionID] = CAST(MessageID AS NVARCHAR(100))
                  + ' - '+ CAST(RunID AS NVARCHAR(100))
                  + ISNULL(' - ' + CAST(PVW_INMessage_Active.TransactionID AS NVARCHAR(100)), '')
                  + ISNULL(' - ' + CAST(INApplicationProcessRunTransaction.ReferenceID AS NVARCHAR(100)), '')
          , [Message] = ISNULL( Message, '')
          , [Detail] = ISNULL( MessageDetail, '')
          , MessageDateTime
          FROM PVW_INMessage_Active
          LEFT OUTER JOIN INApplicationProcessRunTransaction
                  ON INApplicationProcessRunTransaction.INApplicationProcessRunTransactionSK = PVW_INMessage_Active.INApplicationProcessRunTransactionSK
          WHERE
          (
                PVW_INMessage_Active.IsActive = 1
            AND (
                    ( `$(RunID) IS NULL AND RunID = (SELECT TOP 1 RunID FROM INApplicationProcessRun ORDER BY RunDateTime DESC))
                OR ( `$(RunID) IS NOT NULL AND RunID = `$(RunID))
                )
          )
          ORDER BY [ID - RunID - TransactionID]"
      $DS = Invoke-Sqlcmd -ServerInstance “SONG-NAMNGUYEN" -Database 'PDB_Parity4' -Query $Query -Variable $StringArray -AS DataSet

      $DS.Tables[0] | format-table | out-host
    }
  }
}
