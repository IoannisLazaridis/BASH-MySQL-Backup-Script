#   BDBS - Bash Database Backup Script 
The following script automates the process of backingup all the databases. It deletes old backups and store each MySQL database into a specific directory.

#   Configuration

*   Clone the repository into the disired directory
*   Edit the `CUSTOM SETTINGS` section at `mysql_backup.sh` script
*   Edit the `BACKUP_DIR` variable and add the complete path for the backup directory
*   In the `MYSQL Parameters` sub-section add the root credentials of the database `MYSQL_UNAME` and `MYSQL_PWORD`
*   Edit the `KEEP_BACKUPS_FOR` variable to specify the number of days to keep all the backups.

#   Usage
##   Via console 
*   Type: `./mysql_backup.sh`

##   Setting up a cron job
```bash
#CRON:
  # example cron for daily db backup @ 9:15 am
  # min  hr mday month wday command
  # 15   9  *    *     *    /Users/[your user name]/scripts/mysql_backup.sh
```

##  Restore from backup
  ```bash
  $ gunzip < [backupfile.sql.gz] | mysql -u [uname] -p[pass] [dbname]
  ```