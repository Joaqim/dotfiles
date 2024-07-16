#!/usr/bin/env bash

while true; do
    minute=$(date +"%M")
    percent=$(awk "BEGIN {printf \"%.2f\", ($minute/60)*100}")
    echo "$percent"
    sleep 1
done
