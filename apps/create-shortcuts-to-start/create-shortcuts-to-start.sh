#!/usr/bin/env sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GAME_DIR="${1:-$SCRIPT_DIR}"

for GAME_SCRIPT in $(find "$GAME_DIR" -maxdepth 2 -path '*-jc141/start*.sh'); do
    GAME_PATH="$(dirname '$GAME_SCRIPT')"
    GAME_NAME="$(echo ${GAME_PATH##*/} | sed 's;-jc141;;' | tr '.' ' ' )"
    GAME_EXECUTABLE="$(grep -oP '".*\.exe"' $GAME_SCRIPT | rev | cut -d '"' -f 2 | rev)"

   if [ -e "${GAME_PATH}/files/*.\!qB" ]; then
    	echo Skipping incomplete download of \"$GAME_NAME\"
    	continue
    fi


    if [ -z "$GAME_EXECUTABLE" ]; then
    	echo Executable not found for game at \'$GAME_PATH\', maybe game is native?
        continue
    fi
    GAME_EXECUTABLE_PATH="$(find '$GAME_PATH/files/' -name '$GAME_EXECUTABLE')"

    if [ ! -e "$GAME_EXECUTABLE_PATH" ]; then
    	echo Could not find valid path to game executable at "$GAME_PATH/files"
        echo Executable expected: "$GAME_EXECUTABLE"
        continue
    fi

    GAME_SHORTCUT_NAME="$GAME_NAME".desktop
    GAME_SHORTCUT="$GAME_PATH/$GAME_SHORTCUT_NAME"
    GAME_DESKTOP_SHORTCUT="$HOME"/Desktop/"$GAME_SHORTCUT_NAME"

    if [ -e "$GAME_SHORTCUT" ]; then
        echo Skipping \"$GAME_NAME\"
        continue
    fi

    echo Adding game \"$GAME_NAME\"
    sleep 5

    cat > "$GAME_SHORTCUT"<< EOF
[Desktop Entry]
Name=${GAME_NAME}
Comment=Launch '${GAME_NAME}'
TryExec=${GAME_SCRIPT}
Exec=${GAME_SCRIPT}
Terminal=false
Type=Application
Categories=Game;jc141
EOF

    cp -a "$GAME_SHORTCUT" $HOME/Desktop/
    echo Add game \"$GAME_NAME\"
    steamtinkerlaunch addnonsteamgame --exepath="$GAME_EXECUTABLE_PATH" --appname="$GAME_NAME" --launchoptions="gamemoderun %command%" --tags=jc141 --compatibilitytool="GE-Proton9-23"
done