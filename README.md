# 7DaysToDieAutomaticBackup
Script to automatically backup save games and settings after playing 7 Days to Die.

After getting screwed up by corrupted save games multiple times and going crazy over settings being reset when switching between different alphas I decided to create a power shell script that takes care of these things for me. Here's how it works:

1. I start 7 Days to Die by double clicking a shortcut to my script instead of using steam or 7d2d's desktop icon. It took a while to get used to it, but it's just habit.
1. The script will then load the registry settings for that version of the game.
1. It starts 7 Days to Die.
1. <play the game>
1. Once you exit 7 Days to Die, the script saves the registry settings just in case you changed something.
1. It then makes a backup of all your saved games.

I keep one copy of the script for each version of 7 Days to Die I keep around, then just double click the one for the version I want to play. You'll need edit it to adjust the configurations for your computer before you start using it.

The configuration is at the top of the script. They are as follow:
  
  * **backupFolder**: folder where the backup will be placed. Defaults to the user's `Documents\7d2d\backup`.
  * **gameFolder**: where 7 Days to Die is installed. Defaults to steam's default location on drive C. If you have multiple versions installed you'll need to change this.
  * **userDataFolder**: where 7 Days to Die saves the games. Defaults to 7 Days to Die's default. It's useful to change it when playing multiple alphas or mods.
  * **backupName**: folder created for each backup. Defaults to date and time like in `2021_11_05__10-32-25`. 
    Change if you don't want to keep a backup for every time you start the game.
  * **daysBack**: how many days old backups to keep. Not set by default, which means no backups are ever deleted. 
    Be aware that _all files and folders_ in the backup folder will be deleted, so do not use a folder shared with other files.
  * **extraArgs**: additional settings to be used when starting 7 Days to Die. Not set by default. You only set this if you already use something when starting from Steam.
  * **logFolder**: folder to which the log file will be written. Defaults to 7 Days to Die's default of `7DaysToDie_Data` on game's folder.
  * **logName**: what the log file is called. Defaults to 7 Days to Die's default of `output_log_yyyy_MM_dd__HH-mm-ss.txt` like in `output_log__2020-11-28__20-05-27.txt`.
  * **logDaysBack**: how many days old log files to keep. Not set by default, which means no log files are ever deleted.
  * **logNamePattern**: a pattern to find the log files when deleting them. Defaults to `output_log_[-_0-9]*.txt`. If you change `logName`, make a corresponding change here.
  * **settingsFile**: what the registry backup file is called. Defaults to the user's `Documents\7d2d\settings.reg`. 
    If you have multiple alphas installed you'll want to change this.
