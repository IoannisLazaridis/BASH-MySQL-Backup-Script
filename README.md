#   BASH MySQL Backup Script
## Description
The following script automates the process of backingup all the databases. It deletes old backups and store each MySQL database into a specific directory.

## Creating a backup user
Launch the mysql command-line client.

- Create the backup user. For this recipe, we'll call the user backupuser and give the user the password `p455w0rd`. The user can be named anything we wish, and the password should definitely be changed to something unique:
```SQL
CREATE USER 'backupuser'@'localhost'
    IDENTIFIED BY 'p455w0rd';
```

- Next, we will grant our new user a minimal set of permissions, just enough so that it can make backups as follows:
```SQL
GRANT SELECT, SHOW VIEW, LOCK TABLES, RELOAD,
    REPLICATION CLIENT
    ON *.* TO 'backupuser'@'localhost';
```
- Lastly, we will use the FLUSH PRIVILEGES command to force MariaDB to reread the privileges table, which is always a good idea after granting new privileges to a user.
```SQL
FLUSH PRIVILEGES;
```
How it works...

There's no need for the user we use to make backups in order to have every privilege on our databases. They only need a specific subset. For example, they don't need the INSERT or ALTER TABLE privileges since backup users just need to read the tables in our databases. 

##   Configuration

*   Clone the repository into the disired directory
*   Edit the `CUSTOM SETTINGS` section at `mysql_backup.sh` script
*   Edit the `BACKUP_DIR` variable and add the complete path for the backup directory
*   In the `MYSQL Parameters` sub-section add the root credentials of the database `MYSQL_UNAME` and `MYSQL_PWORD`
*   Edit the `KEEP_BACKUPS_FOR` variable to specify the number of days to keep all the backups.

##   Usage
###   Via console 
*   Type: `./mysql_backup.sh`

###   Setting up a cron job
```bash
#CRON:
  # example cron for daily MySQL Database backup @ 9:15 am
  # min  hr mday month wday command
  # 15   9  *    *     *    /SCRIPT/PATH/mysql_backup.sh
```

###  Restore from backup
  ```bash
  $ gunzip < [backupfile.sql.gz] | mysql -u [uname] -p[pass] [dbname]
  ```
