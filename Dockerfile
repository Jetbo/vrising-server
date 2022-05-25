FROM debian:bullseye-slim

# Install Certs
RUN apt-get update && apt-get install -y ca-certificates

# Update sources
RUN printf "deb https://deb.debian.org/debian bullseye main contrib non-free \
  \ndeb-src https://deb.debian.org/debian bullseye main contrib non-free \
  \ndeb https://deb.debian.org/debian-security/ bullseye-security main contrib non-free \
  \ndeb-src https://deb.debian.org/debian-security/ bullseye-security main contrib non-free \
  \ndeb https://deb.debian.org/debian bullseye-updates main contrib non-free \
  \ndeb-src https://deb.debian.org/debian bullseye-updates main contrib non-free" > /etc/apt/sources.list

# Install SteamCMD
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && dpkg --add-architecture i386 \
  && apt-get update \
  && echo steam steam/question select "I AGREE" | debconf-set-selections \
  && apt-get install -y lib32gcc-s1 xvfb steamcmd wine \
  && apt-get autoremove

# Create user
RUN groupadd --gid 1000 steam \
  && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash steam
USER steam
WORKDIR /home/steam

# Install game
RUN mkdir -p /home/steam/.steam/root \
  && mkdir -p /home/steam/.steam/steam \
  && mkdir -p /home/steam/v-rising/data
RUN /usr/games/steamcmd +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit

# Setup Volume
VOLUME ["/home/steam/v-rising/data"]

# Configure wine
ENV DISPLAY=:0
RUN winecfg

# Start scripts
ENV SERVER_NAME=default
COPY --chown=steam:steam scripts/start-server.bash .
COPY --chown=steam:steam server_settings/ServerGameSettings.json /home/steam/v-rising/data/ServerGameSettings.json
COPY --chown=steam:steam server_settings/ServerHostSettings.json /home/steam/v-rising/data/ServerHostSettings.json
RUN chmod +x start-server.bash
CMD [ "./start-server.bash", "$SERVER_NAME" ]
