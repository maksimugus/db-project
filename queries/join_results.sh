#!/bin/bash

output_file="./results/combined_stats.txt"
echo "Name                | Best: Worst: Average" > "$output_file"

for sql_file in /analyse/*.sql; do
    sql_file_name=$(basename "$sql_file")
    sql_file_name=${sql_file_name%.*}
    echo "$sql_file_name" >> "$output_file"
    for file in results/*/stats-*.txt; do
        file_name=$(basename "$file")
        file_name_without_extension="${file_name%%.*}"
        date_string="${file_name_without_extension#stats-}"
        grep "$sql_file_name" "$file" | awk -v a="$date_string" -F ':' '{print a " | " $2 ": " $3 ": " $4}' >> "$output_file"
    done
done

echo "Done"