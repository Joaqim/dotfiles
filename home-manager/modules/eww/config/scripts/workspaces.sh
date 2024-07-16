#!/usr/bin/env bash

trap "exit" SIGTERM SIGINT

iconBasePath="/home/jq/dotfiles/home-manager/modules/eww/config/images"

focusedIcon="ws-focus.png"
nonEmptyIcon="ws-active.png"
emptyIcon="ws-inactive.png"

while true; do

    focusedWorkspaceID=$(hyprctl activeworkspace | grep -Po 'workspace ID \K\d+')

    declare -A workspaceStates=( [1]=0 [2]=0 [3]=0 [4]=0 )

    while IFS= read -r line; do
        if [[ $line =~ workspace\ ID\ ([1-4]) ]]; then
            workspaceID=${BASH_REMATCH[1]}
        elif [[ $line =~ windows:\ ([0-9]+) ]]; then
            windows=${BASH_REMATCH[1]}
            if [[ $windows -gt 0 ]]; then
                workspaceStates[$workspaceID]=1
            fi
        fi
    done < <(hyprctl workspaces)

    for workspaceID in "${!workspaceStates[@]}"; do
        iconPath="$iconBasePath/$emptyIcon" 

        if [[ $workspaceID -eq $focusedWorkspaceID ]]; then
            iconPath="$iconBasePath/$focusedIcon" 
        elif [[ ${workspaceStates[$workspaceID]} -eq 1 ]]; then
            iconPath="$iconBasePath/$nonEmptyIcon"
        fi

        eww update "workspaceIcon$workspaceID=$iconPath"
    done

    sleep 0.1 # Adjusted sleep time to reduce CPU usage
done
