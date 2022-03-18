#!/bin/bash
#==============================================================================
#TITLE:            mysql_backup.sh
#DESCRIPTION:      Script for automating the daily mysql backups
#AUTHOR:           Ioannis Lazaridis
#DATE:             26-05-2021
#VERSION:          1.0
#USAGE:            ./mysql_backup.sh

#==============================================================================
# CUSTOM SETTINGS
#==============================================================================

# MYSQL Parameters
MYSQL_UNAME=MYSQL_USERNAME
MYSQL_PWORD=MYSQL_PASSWORD

# Directory to store the backup files
BACKUP_DIR=/PATH/TO/STORE/BACKUP/FILES/

# Don't backup databases with these names
# Example: starts with mysql (^mysql) or ends with _schema (_schema$)
IGNORE_DB="(^mysql|_schema$)"

# include mysql and mysqldump binaries for cron bash user
PATH=$PATH:/usr/local/mysql/bin

# Number of days to keep backups
KEEP_BACKUPS_FOR=7 #days

#==============================================================================
# METHODS
#==============================================================================

# YYYY-MM-DD
TIMESTAMP=$(date +%F)

#   Function to delete old backup files
function delete_old_backups(){
  echo "Deleting $BACKUP_DIR/*.sql.gz older than $KEEP_BACKUPS_FOR days"
  find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +$KEEP_BACKUPS_FOR -exec rm {} \;
}

#   Function to initiate login into MariaDB
function mysql_login() {
  local mysql_login="-u $MYSQL_UNAME"
  if [ -n "$MYSQL_PWORD" ]; then
    local mysql_login+=" -p$MYSQL_PWORD"
  fi
  echo $mysql_login
}

#   Function to list all databases
function database_list() {
  local show_databases_sql="SHOW DATABASES WHERE \`Database\` NOT REGEXP '$IGNORE_DB'"
  echo $(mysql $(mysql_login) -e "$show_databases_sql"|awk -F " " '{if (NR!=1) print $1}')
}

#   Function to show status
function echo_status(){
  printf '\r';
  printf ' %0.s' {0..100}
  printf '\r';
  printf "$1"'\r'
}

#   Function to start backup  into the backup directory. Also showing the proggress
function backup_database(){
    backup_file="$BACKUP_DIR/$TIMESTAMP.$database.sql.gz"
    output+="$database => $backup_file\n"
    echo_status "...backing up $count of $total databases: $database"
    $(mysqldump $(mysql_login) $database | gzip -9 > $backup_file)
}


function backup_databases(){
  local databases=$(database_list)
  local total=$(echo $databases | wc -w | xargs)
  local output=""
  local count=1
  for database in $databases; do
    backup_database
    local count=$((count+1))
  done
  echo -ne $output | column -t
}

function hr(){
  printf '=%.0s' {1..100}
  printf "\n"
}

#==============================================================================
# RUN SCRIPT
#==============================================================================
delete_old_backups
hr
backup_databases
hr
printf "All backed up!\n\n"
