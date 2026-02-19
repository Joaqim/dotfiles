#!/usr/bin/env bash
_HISTORY_FILE="/home/jq/Documents/org/mpv-history.org"
_LINK_CAPTURE_REGEX="^\*\*\* (.*)(\W:)(.*):<(.*)>:<(.*)>:<(.*)>:.*$"
[ -z "$_HISTORY_FILE" ] && echo "Missing history file at: $_HISTORY_FILE" && exit 1

mapfile -t history <<< "$(tail "$_HISTORY_FILE" -n 150)"
options=()
for (( i = ${#history[@]}; i--; )); do
    if [[ "${history[i]}" =~ $_LINK_CAPTURE_REGEX ]]; then
        current_time="${BASH_REMATCH[5]}"
        runtime="${BASH_REMATCH[6]}"
        current_time_in_sec=$(date -d "$current_time" +%s)
        runtime_in_sec=$(date -d "$runtime" +%s)
        _THRESHOLD_IN_SEC=300 # 5 minutes

        if [ $((runtime_in_sec - current_time_in_sec)) -lt $_THRESHOLD_IN_SEC ]; then
            continue
        fi
        options+=("${BASH_REMATCH[1]}")
        options+=("${BASH_REMATCH[1]} - ${BASH_REMATCH[3]} - $current_time/$runtime")
    fi
done

result=$(kdialog --geometry 1200x900+300+300 --menu "Choose entry to play with MPV" "${options[@]}")

if [ -z "$result" ]; then
    exit 0
fi
mpv "$result"
