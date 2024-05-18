#!/bin/bash

db=$POSTGRES_DB
user=$POSTGRES_USER
password=$POSTGRES_PASSWORD
host=$POSTGRES_HOST
port=$POSTGRES_PORT
target_version=${VERSION:-latest}

target_x=$(echo "$target_version" | cut -d '.' -f 1)
target_y=$(echo "$target_version" | cut -d '.' -f 2)
target_z=$(echo "$target_version" | cut -d '.' -f 3)

for migration_file in $(find migrations/*.sql | sort -V); do

    if [[ "$target_version" != "latest" ]]; then
        x=$(basename "$migration_file" | cut -d'.' -f 1)
        y=$(basename "$migration_file" | cut -d'.' -f 2)
        z=$(basename "$migration_file" | cut -d'.' -f 3)

        if [[ "$x" -gt "$target_x" ]]; then
            break
        fi

        if [[ "$x" -eq "$target_x" ]] && [[ "$y" -gt "$target_y" ]]; then
            break
        fi

        if [[ "$y" -eq "$target_y" ]] && [[ "$z" -gt "$target_z" ]]; then
            break
        fi
    fi

    echo "Applying migration: $migration_file"
    PGPASSWORD="$password" psql -U "$user" -d "$db" -p "$port" -h "$host" -f "$migration_file"
done

echo "Migration complete. Current version: $target_version."