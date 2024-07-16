#!/usr/bin/env bash

current_value=$(eww get volumeButtons)

if [ "$current_value" = "true" ]; then
    eww update volumeButtons=false
else
    eww update volumeButtons=true
fi