target_version=${VERSION:-latest}

for migration_file in $(ls migrations/*.sql | sort -V); do

    if [[ "$target_version" != "latest" ]]; then

        version=$(basename $migration_file | cut -d'_' -f1)

        if [[ "$version" > "${target_version}" ]]; then
            break
        fi
    fi

    echo "Applying migration: $migration_file"
    psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f $migration_file
done

echo "Migration complete. Current version: $target_version."