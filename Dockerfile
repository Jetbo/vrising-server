FROM steamcmd/steamcmd:ubuntu-20

# Install Wine
RUN apt-get update \
  && apt-get install -y --no-install-recommends xvfb wine \
  && rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd --gid 1000 steam \
  && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash steam
USER steam
WORKDIR /home/steam
ENV DEBIAN_FRONTEND=noninteractive

# Install game
RUN mkdir -p /home/steam/.steam/root \
  && mkdir -p /home/steam/.steam/steam \
  && mkdir -p /home/steam/v-rising/data/Settings
RUN /usr/games/steamcmd +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit

# Note Volume
VOLUME ["/home/steam/v-rising/data"]

# Note ports
EXPOSE 27015-27016/udp

# Configure wine
ENV DISPLAY=:0
RUN WINEARCH=win64 winecfg

# Start scripts
ENV SERVER_NAME=default
COPY --chown=steam:steam scripts/start-server.bash .
COPY --chown=steam:steam server_settings/ServerGameSettings.json /home/steam/v-rising/data/Settings/ServerGameSettings.json
COPY --chown=steam:steam server_settings/ServerHostSettings.json /home/steam/v-rising/data/Settings/ServerHostSettings.json
RUN chmod +x start-server.bash
CMD [ "./start-server.bash", "$SERVER_NAME" ]
