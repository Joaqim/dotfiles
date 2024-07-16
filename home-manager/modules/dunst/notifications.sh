#!/usr/bin/env bash

IDENTIFIER="$1"

WORKSPACE_ID=$(hyprctl workspaces | grep -B4 -i "$IDENTIFIER" | grep 'workspace ID' | awk '{print $3}')

if [ -n $WORKSPACE_ID ]; then
    hyprctl dispatch movetoworkspace $WORKSPACE_ID
fi

if [ -n "$IDENTIFIER" ]; then
    hyprctl dispatch focuswindow $IDENTIFIER
fi

