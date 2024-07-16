#!/usr/bin/env bash

current_volume=$(amixer get Master | grep -oP "\d+(?=%)" | head -1)

mute_state=$(amixer get Master | grep -oP "\[(on|off)\]" | head -1)

if [[ $mute_state == "[off]" ]]; then
    echo "off"
else
    echo "$current_volume"
fi

