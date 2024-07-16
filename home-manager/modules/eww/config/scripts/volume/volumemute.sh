#!/usr/bin/env bash

if amixer get Master | grep -q '\[off\]'; then
    amixer set Master unmute
else
    amixer set Master mute
fi
