#!/usr/bin/env bash

#Open powermenu
current_value=$(eww get power)

if [ "$current_value" = "true" ]; then
    eww update power=false
else
    eww update power=true
fi