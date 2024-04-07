target_version=${VERSION:latest}
for migration_file in $(ls test_migrations/*.sql | sort -V); do
    version=$(basename $migration_file | cut -d'_' -f1)
    if [ "$version" -gt "${target_version}" ]; then
        break
    fi
    echo "Applying migration: $migration_file"
    psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f $migration_file
done
echo "Migration complete. Version: ${target_version}"