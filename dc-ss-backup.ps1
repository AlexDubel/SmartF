$systemStatePolicy  = New-WBPolicy
$BackupDrive        = New-WBBackupTarget -NetworkPath '\\radmin.kvcloud.local\Backups\'
Add-WBSystemState   -Policy $systemStatePolicy
Add-WBBackupTarget  -Policy $systemStatePolicy -Target $BackupDrive
Start-WBBackup      -Policy $systemStatePolicy