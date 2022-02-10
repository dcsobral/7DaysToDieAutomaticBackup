### Change the backup path to a suitable location ###
$backupFolder = "$($env:USERPROFILE)\Documents\7d2d\backup"

### Change the game folder if needed ###
$gameFolder = "C:\Program Files (x86)\Steam\steamapps\common\7 Days To Die"

### If you are playing multiple versions/modded,               ###
### I recommend changing this to a new folder for each version ###
$userDataFolder = "$($env:APPDATA)\7DaysToDie"

### Change this if you don't want a backup every time you start ###
$backupName = Get-Date -Format "yyyy_MM_dd__HH-mm-ss"
# (alternative) Make a new backup folder every day, but 
#               overwrite backups when restarting in the 
#               same day
# $backupName = Get-Date -Format "yyyyMMdd"
#
# (alternative) use a single backup folder
# $backupName = "backup"

### Uncomment to delete old backups  ###
### change number of days as desired ###
#$daysBack = "-30"

### Extra starting arguments ###
#$extraArgs = "-popupwindow"

### Change if you want the log file on a different path ###
### or with a different name                            ###
$logFolder = "$($gameFolder)\7DaysToDie_Data"
$logName = "output_log_$(Get-Date -Format `"yyyy_MM_dd__HH-mm-ss`").txt"

### Uncomment to remove old log files and            ###
#$logDaysBack = "-30"

### set logNamePattern to avoid deleting other files ###
$logNamePattern = "output_log_[-_0-9]*.txt"

### Save settings when exiting and restoring before starting ###
### Use different files for different 7 Days to Die versions ###
$settingsFile = "$($env:USERPROFILE)\Documents\7d2d\settings.reg"

#######################################
### No more changes below this line ###
#######################################

$savesPath = "$($userDataFolder)\Saves\*"
$backupPath = "$($backupFolder)\$($backupName)"
$logPath = "$($logFolder)\$($logName)"
$CurrentDate = Get-Date

# Restore settings
if ((Test-Path variable:settingsFile) -and (Test-Path -Path "$settingsFile")) {
  echo "Loading settings from $($settingsFile)"
  reg import "$settingsFile"
}

# Start 7 Days to Die and wait
Start-Process -FilePath "7DaysToDie.exe" -WorkingDirectory "$gameFolder" `
  -ArgumentList "-logfile `"$($logPath)`" `"-userdatafolder=$($userDataFolder)`" $extraArgs" `
  -Wait

if (Test-Path variable:settingsFile) {
  # Save settings
  reg export "HKEY_CURRENT_USER\SOFTWARE\The Fun Pimps\7 Days To Die" "$settingsFile" /y
}

# Make backup
if (Test-Path variable:backupFolder) {
  # Remove old backups
  if (Test-Path variable:daysBack) {
    $DatetoDelete = $CurrentDate.AddDays($daysBack)
    $backupFolders = @(Get-ChildItem -Path "$backupFolder" -Directory |? { $_.LastWriteTime -lt $DatetoDelete })
    if ($backupFolders.Count -gt 0) {
      echo "Deleting backup folders at '$backupPath':"
      $backupFolders |% { "$_" }
      $backupFolders |% { Remove-Item "$($_.fullname)" -Force -Recurse -WhatIf }
    }
  } else {
    echo "Old backup folder removal not configured"
  }

  echo "Creating backup $($backupName) at $($backupFolder)"
  New-Item -Path "$backupPath" -ItemType Directory | Out-Null
  Copy-Item -Path "$savesPath" -Destination "$backupPath" -Recurse -Force
}

# Remove old log files
if (Test-Path variable:logDaysBack) {
  $DatetoDelete = $CurrentDate.AddDays($logDaysBack)
  $logFiles = @(Get-ChildItem -Path "$logFolder" -File |? { "$_" -Match "$logNamePattern" } |? { $_.LastWriteTime -lt $DatetoDelete })
  if ($logFiles.Count -gt 0) {
    echo "Deleting log files at '$logFolder':"
    $logFiles |% { "$_" }
    $logFiles |% { Remove-Item "$($_.fullname)" -Force -Recurse -WhatIf }
  }
} else {
  echo "Old log file removal not configured"
}
