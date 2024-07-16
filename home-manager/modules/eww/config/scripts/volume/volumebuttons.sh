#!/usr/bin/env bash

trap "echo 'Script terminated'; exit" SIGTERM SIGINT

iconBasePath="/home/jq/dotfiles/home-manager/modules/eww/config/images"

volumeDownIconNormal="minus.png"
volumeDownIconMin="minusmax.png"
volumeUpIconNormal="plus.png"
volumeUpIconMaxed="plusmax.png"
volumeMuteIconNormal="mute.png"
volumeMuteIconMuted="muteon.png"
lastVolumeDownIconName=""
lastVolumeUpIconName=""
lastVolumeMuteIconName=""

while true; do
    current_volume=$(amixer get Master | grep -oP '\[\d+%\]' | tr -d '[]%' | head -n 1)
    is_muted=$(amixer get Master | grep -q '\[off\]' && echo "yes" || echo "no")

    volumeDownIconName=$volumeDownIconNormal
    if [ "$current_volume" -eq 0 ]; then
        volumeDownIconName=$volumeDownIconMin
    fi

    volumeUpIconName=$volumeUpIconNormal
    if [ "$current_volume" -eq 100 ]; then
        volumeUpIconName=$volumeUpIconMaxed
    fi

    volumeMuteIconName=$volumeMuteIconNormal
    if [ "$is_muted" = "yes" ]; then
        volumeMuteIconName=$volumeMuteIconMuted
    fi

    if [ "$volumeDownIconName" != "$lastVolumeDownIconName" ]; then
        eww update "volumeDownIcon=$iconBasePath/$volumeDownIconName"
        lastVolumeDownIconName=$volumeDownIconName
    fi

    if [ "$volumeUpIconName" != "$lastVolumeUpIconName" ]; then
        eww update "volumeUpIcon=$iconBasePath/$volumeUpIconName"
        lastVolumeUpIconName=$volumeUpIconName
    fi

    if [ "$volumeMuteIconName" != "$lastVolumeMuteIconName" ]; then
        eww update "volumeMuteIcon=$iconBasePath/$volumeMuteIconName"
        lastVolumeMuteIconName=$volumeMuteIconName
    fi

    sleep 0.1
done