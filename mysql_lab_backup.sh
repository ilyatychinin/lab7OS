#!/bin/bash

set -e

echo "starting database backup"
CONTAINER_NAME="mysql_lab9"
USER="root"
BACKUP_DIR="/home/ilya/mysql/backup_dir"
RETENTION_DAYS=7


BACKUP_FILE="${BACKUP_DIR}/full_backup_$(date +%Y%m%d_%H%M%S).sql"
echo "backup creating: $BACKUP_FILE"

docker container exec "$CONTAINER_NAME" \
	mysqldump -u "$USER" -p"mysql_root_passwd.txt" \
	--all-databases \
	> "$BACKUP_FILE"

echo "backup succesfull create"

echo "cleaning old backups"
find "$BACKUP_DIR" -name "full_backup_*.sql" -type f -mtime +$RETENTION_DAYS -delete
echo "old backups succesfull clean" 
