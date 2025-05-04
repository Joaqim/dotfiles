#!/usr/bin/env sh
set -exo pipefail

[ "$#" -eq 2 ] || { printf "Usage: %s <path_to_executable> <game_name>" "$0" ; exit 1; }
[ -f "$1" ] || { printf "%s is not a file" "$1"; exit 1; }

steamtinkerlaunch addnonsteamgame --exepath="$1" --appname="$2" --launchoptions="gamemoderun %command%"