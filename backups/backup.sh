#!/bin/bash

db=$POSTGRES_DB
user=$POSTGRES_USER
password=$POSTGRES_PASSWORD
host=$POSTGRES_HOST
port=$POSTGRES_PORT
interval=$BACKUP_INTERVAL
retain_count=$BACKUP_RETAIN_COUNT

backup_folder_name="backup_files"
mkdir -p "$backup_folder_name"

while true; do
    backup_name=$(date +"%Y-%m-%d_%H-%M-%S")
    backup_name="$backup_folder_name/$backup_name"
    PGPASSWORD="$password" pg_dump -U "$user" -d "$db" -p "$port" -h "$host" > "$backup_name"
    echo "Backup created!"

    backups=( "$(ls -t)" )
    while [ ${#backups[@]} -gt "$retain_count" ]; do
        rm -f "${backups[-1]}"
        backups=( "${backups[@]:0:${#backups[@]}-1}" )
    done

    sleep $((interval * 3600))
done