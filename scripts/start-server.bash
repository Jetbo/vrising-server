#!/bin/bash

set -e

# Install/Update server
echo "---Installing/Updating VRising Dedicated Server---"
/usr/games/steamcmd +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit

# Run server in Wine
echo "---Starting VRising Dedicated Server---"
Xvfb :0 -screen 0 640x480x24:32 -nolisten tcp -nolisten unix &
wine64 /home/steam/v-rising/VRisingServer.exe -persistentDataPath "/home/steam/v-rising/data" -serverName "$1"
