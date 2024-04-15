#!/bin/bash

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
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
while [ $i -lt $USERS_NUMBER ]; do
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
    CREATE USER user$i;
    GRANT group_role TO user$i;
EOSQL
((i++))
done

echo "Roles created successfully!"