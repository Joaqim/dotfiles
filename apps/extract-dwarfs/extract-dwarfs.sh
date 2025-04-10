#!/usr/bin/env sh
# Navigate to the directory of the script
#SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || { echo "Failed to navigate to script directory. Exiting."; exit 1; }

if [ -e ./.lock ]; then
   echo Found lockfile at $PWD/.lock,  Trying again after 1 minute...
   sleep 60
   if [ -e ./.lock ]; then
     echo Lockfile exists at $PWD/.lock, aborting
     exit 1
   fi
fi
touch ./.lock
#find *-jc141 \( -name 'actions.sh' -o -name 'settings.sh' \)  -execdir bash -c "[ ! -e ./files/game-root ] && [ -e ./files/*.dwarfs ] && pwd && sleep 5 && bash *s.sh dwarfs-extract && rm ./files/*.dwarfs" {} \;
find *-jc141 -name 'actions.sh'  -execdir bash -c "[ ! -e ./files/game-root ] && [ -e ./files/*.dwarfs ] && pwd && sleep 5 && bash actions.sh dwarfs-extract && rm ./files/*.dwarfs" {} \;
find *-jc141 -name 'settings.sh'  -execdir bash -c "[ ! -e ./files/groot ] && [ -e ./files/*.dwarfs ] && pwd && sleep 5 && bash settings.sh extract && rm ./files/*.dwarfs" {} \;
rm ./.lock