#!/usr/bin/env bash

while true; do
    hour=$(date +"%I")
    percent=$(awk "BEGIN {printf \"%.2f\", (($hour % 12)/12)*100}")
    echo "$percent"
    sleep 1
done
