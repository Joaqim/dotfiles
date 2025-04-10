#!/usr/bin/env sh
set -exo pipefail

export ONSTEAMDECK=1 # Allows non-gui execution
steamtinkerlaunch addnonsteamgame --exepath="$1" --appname="$2" --launchoptions="gamemoderun %command%"