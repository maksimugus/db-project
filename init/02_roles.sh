#!/bin/bash

db=$POSTGRES_DB
user=$POSTGRES_USER
password=$POSTGRES_PASSWORD
host=$POSTGRES_HOST
port=$POSTGRES_PORT

PGPASSWORD="$password" psql -U "$user" -d "$db" -p "$port" -h "$host" <<-EOSQL
CREATE USER reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;

CREATE USER writer;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO writer;

CREATE USER analytic;
GRANT SELECT ON films TO analytic;

CREATE ROLE group_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO group_role;
EOSQL

i=0
while [ $i -lt "$USERS_NUMBER" ]; do
    PGPASSWORD="$password" psql -U "$user" -d "$db" -p "$port" -h "$host" <<-EOSQL
    CREATE USER user$i;
    GRANT group_role TO user$i;
EOSQL
((i++))
done

echo "Roles created successfully!"