#!/usr/bin/env bash

current_value=$(eww get system)

if [ "$current_value" = "true" ]; then
    eww update system=false
else
    eww update system=true
fi