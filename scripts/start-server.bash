#!/bin/bash

set -e

# Install/Update server
echo "---Installing/Updating VRising Dedicated Server---"
/usr/games/steamcmd +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit

# Run server in Wine
echo "---Starting VRising Dedicated Server---"
WINEARCH=win64 winecfg
sleep 10 # DO NOT REMOVE! For some reason winecfg takes longer to run than the command exit
cd /home/steam/v-rising/
xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine64 ./VRisingServer.exe -persistentDataPath "Z:/home/steam/v-rising/data" -serverName "$1" -gamePort 27015 -queryPort 27016
