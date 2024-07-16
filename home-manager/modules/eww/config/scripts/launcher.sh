#!/usr/bin/env bash

current_value=$(eww get launch)

if [ "$current_value" = "true" ]; then
    eww update launch=false
else
    eww update launch=true
fi