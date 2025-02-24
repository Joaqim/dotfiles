#!/usr/bin/env bash
_HISTORY_FILE="/home/jq/Documents/org/mpv-history.org"
_LINK_CAPTURE_REGEX="^\*\*\* (\S*)(\W:)(.*):<(.*)>:<(.*)>:<(.*)>:.*$"
[ -z $_HISTORY_FILE ] && echo "Missing history file at: ${_HISTORY_FILE}" && exit 1

history=$(tail "${_HISTORY_FILE}" -n 50)
links=()
options=()
while IFS= read -r line; do
    if [[ "$line" =~ $_LINK_CAPTURE_REGEX ]]; then
        current_time="${BASH_REMATCH[5]}"
        runtime="${BASH_REMATCH[6]}"
        current_time_in_sec=$(date -d "$current_time" +%s)
        runtime_in_sec=$(date -d "$runtime" +%s)
        _EPSILON_IN_SEC=300 # 5 minutes

        if [ $((runtime_in_sec - current_time_in_sec)) -lt $_EPSILON_IN_SEC ]; then
            continue
        fi
        links+=("${BASH_REMATCH[1]}")
        options+=("${BASH_REMATCH[1]}")
        options+=("${BASH_REMATCH[1]} - ${BASH_REMATCH[3]} - $current_time/$runtime")
    fi
done <<< "$history"
# Reverse array
options=$(printf '%s\n' "${options[@]}" | tac | tr '\n' ' '; echo)

result=$(kdialog --geometry 1200x900+300+300 --menu dialog "${options[@]}")

if [ -z "$result" ]; then
    exit 0
fi
mpv "$result"