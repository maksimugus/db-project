#!/bin/bash

db=$POSTGRES_DB
user=$POSTGRES_USER
port=$POSTGRES_PORT
host=$POSTGRES_HOST
attempts=$QUERY_RUN_ATTEMPTS

path="$PWD/execution_reports"
mkdir -p "$path" 2>/dev/null
report_file="$path/$(date +"%Y-%m-%d_%H-%M-%S").csv"
echo "query;best;avg;worst" >> "$report_file"

for query_file in "$PWD"/*.sql; do
    query_name=$(basename "$query_file")
    query_name=${query_name%.*}
    results=()

    echo "Started $query_name"
    for ((i = 0; i < attempts; i++)); do
        res=$(PGPASSWORD="$POSTGRES_PASSWORD" psql -U "$user" -d "$db" -p "$port" -h "$host" -f "$query_file" \
        | grep "Execution Time" \
        | awk -F '[: ]+' '{print $4}')
        results+=("$res")
    done
    echo "Finished $query_name"

    best=${results[0]}
    worst=${results[0]}
    sum=0
    for i in "${results[@]}"; do
        if (( $(echo "$i<$best" | bc -l) )); then
            best=$i
        fi
        if (( $(echo "$i>$worst" | bc -l) )); then
            worst=$i
        fi
        sum=$(echo "$sum+$i" | bc -l)
    done
    avg=$(echo "scale=3; $sum/3" | bc -l)

    echo "$query_name;$best;$avg;$worst" >> "$report_file"
done
