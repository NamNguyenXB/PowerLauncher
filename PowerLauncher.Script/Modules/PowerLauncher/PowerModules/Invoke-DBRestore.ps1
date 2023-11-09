﻿if ($null -eq (Get-Command Invoke-DBRestore -EA SilentlyContinue)) {

  function Invoke-DBRestore {
    param($Module, $Config)

    $InstallFolder = $Config.InstallFolder
    $DB = $Config.Database
    $SqlServer = $Config.SqlServer
    $BackupFile = $Module.BackupFile
    $BackupLogFile = $Module.BackupLogFile
    $BackupFolder = $Module.BackupFolder

    if (!$BackupFolder) {
      $BackupFolder = "$InstallFolder/DBBackups"
    }

    $Disk = "$BackupFolder/$BackupFile"
    $LogDisk = "$BackupFolder/$BackupLogFile"

    sqlcmd -S $SqlServer -E -Q "ALTER DATABASE $DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
    sqlcmd -S $SqlServer -E -Q "BACKUP LOG $DB TO DISK='$LogDisk' WITH NORECOVERY"
    sqlcmd -S $SqlServer -E -Q "RESTORE DATABASE $DB FROM DISK=N'$Disk' WITH NORECOVERY"
    sqlcmd -S $SqlServer -E -Q "RESTORE DATABASE $DB WITH RECOVERY"
    sqlcmd -S $SqlServer -E -Q "ALTER DATABASE $DB SET MULTI_USER"
  }
}