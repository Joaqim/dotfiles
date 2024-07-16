#!/usr/bin/env bash

while true; do
    second=$(date +"%S")
    percent=$(awk "BEGIN {printf \"%.2f\", ($second/60)*100}")
    echo "$percent"
    sleep 1
done
