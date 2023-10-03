if ($null -eq (Get-Command Invoke-DBBackup -EA SilentlyContinue)) {
  function Invoke-DBBackup {
    param($Launcher, $Config)

    if ($Launcher.Run) {
      $InstallFolder = $Config.InstallFolder
      $DB = $Config.Database
      $SqlServer = $Config.SqlServer
      $BackupFile = $Launcher.BackupFile
      $BackupFolder = $Launcher.BackupFolder

      if (!$BackupFolder) {
        $BackupFolder = "$InstallFolder/DBBackups"
        if(-not (Test-Path $BackupFolder)){
          New-Item -Path $BackupFolder -ItemType "directory"
        }
      }

      if ($null -eq $BackupFile){
        $BackupFile = Read-Host "Please input the output .bak file name"
      }
      if ($null -eq $BackupFile -or "" -eq $BackupFile){
        $BackupFile = "PDB_" + (Get-Date -Format "yyyyMMddHHmmss") + ".bak"
      }
      $Disk = "$BackupFolder/$BackupFile"
      sqlcmd -S $SqlServer -E -Q "BACKUP DATABASE $DB TO DISK='$Disk' WITH FORMAT"
    }
  }
}