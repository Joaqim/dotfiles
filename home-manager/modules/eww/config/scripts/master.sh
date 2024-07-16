#!/usr/bin/env bash

start_script() {
    local script_dir="$1"
    local script_name="$2"

    pushd "${script_dir}" > /dev/null
    chmod +x "${script_name}"
    ./"${script_name}" &> /dev/null &
    disown
    popd > /dev/null
}

ensure_running() {
    local script_path="$1"
    local script_name=$(basename "$script_path")

    if ! pgrep -f "${script_name}" > /dev/null; then
        local script_dir=$(dirname "${script_path}")
        start_script "${script_dir}" "${script_name}"
    fi
}

if ! pgrep -x "eww" > /dev/null; then
    eww daemon &
    sleep 2
fi

eww open centerPanel
while ! eww active-windows | grep -q "centerPanel"; do
    sleep 1
done

ensure_running "/home/jq/dotfiles/home-manager/modules/eww/config/scripts/workspaces.sh"
ensure_running "/home/jq/dotfiles/home-manager/modules/eww/config/scripts/volume/volumebuttons.sh"