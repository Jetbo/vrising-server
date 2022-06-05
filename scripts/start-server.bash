#!/bin/bash

set -e

# Install/Update server
echo "---Updating VRising Dedicated Server---"
/usr/games/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit
cat /home/steam/.steam/steam/logs/stderr.txt # show errors, if any


# Bootstrap settings files
echo "---Loading VRising Dedicated Server Settings---"
mkdir -p /home/steam/v-rising/data/Settings/
mv /home/steam/v-rising/adminlist.txt /home/steam/v-rising/data/Settings/adminlist.txt
mv /home/steam/v-rising/ServerGameSettings.json /home/steam/v-rising/data/Settings/ServerGameSettings.json
mv /home/steam/v-rising/ServerHostSettings.json /home/steam/v-rising/data/Settings/ServerHostSettings.json

# Start wine with a faked display
echo "---Starting VRising Dedicated Server---"
cd /home/steam/v-rising/
xvfb-run \
  --auto-servernum \
  --server-args='-screen 0 640x480x24:32 -nolisten tcp -nolisten unix' \
  bash -c "wine64 ./VRisingServer.exe -persistentDataPath \"/home/steam/v-rising/data\" -serverName \"$1\" -gamePort 27015 -queryPort 27016"
