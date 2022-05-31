FROM ubuntu:22.10

ENV DEBIAN_FRONTEND=noninteractive

# Install Certs and basics requirements
RUN apt-get update && apt-get install -y ca-certificates openssl apt-transport-https \
  software-properties-common locales tzdata wget \
  && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata \
  && add-apt-repository multiverse \
  && dpkg --add-architecture i386

# Set locale
ENV TZ=UTC
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install SteamCMD and Wine
RUN apt-get update \
  && echo steam steam/question select "I AGREE" | debconf-set-selections \
  && echo steam steam/license note "" | debconf-set-selections \
  # Libraries required for Steam.
  && apt-get install -y libgl1-mesa-glx:i386 steamcmd \
  # Libraries required for Wine
    xvfb xserver-xorg wine64 winetricks winbind

# Create user
RUN groupadd --gid 1000 steam \
  && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash steam
USER steam
WORKDIR /home/steam

# Make game folders
RUN mkdir -p /home/steam/.steam/root \
  && mkdir -p /home/steam/.steam/steam \
  && mkdir -p /home/steam/v-rising/data \
  && mkdir -p /home/steam/v-rising/dotnet

# Install dotnet 6
RUN wget https://download.visualstudio.microsoft.com/download/pr/dc930bff-ef3d-4f6f-8799-6eb60390f5b4/1efee2a8ea0180c94aff8f15eb3af981/dotnet-sdk-6.0.300-linux-x64.tar.gz \
  && wget https://download.visualstudio.microsoft.com/download/pr/a0e9ceb8-04eb-4510-876c-795a6a123dda/6141e57558eddc2d4629c7c14c2c6fa1/aspnetcore-runtime-6.0.5-linux-x64.tar.gz \
  && tar zxf dotnet-sdk-6.0.300-linux-x64.tar.gz -C /home/steam/v-rising/dotnet \
	&& tar zxf aspnetcore-runtime-6.0.5-linux-x64.tar.gz -C /home/steam/v-rising/dotnet \
  && rm -f dotnet-sdk-6.0.300-linux-x64.tar.gz aspnetcore-runtime-6.0.5-linux-x64.tar.gz
ENV DOTNET_ROOT=/home/steam/v-rising/dotnet
ENV PATH=$PATH:$DOTNET_ROOT

# Install app
RUN /usr/games/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir "/home/steam/v-rising" +login anonymous +app_update 1829350 +quit

# Note Volume
VOLUME ["/home/steam/v-rising/data"]
# Note ports
EXPOSE 27015-27016/udp

# Copy to data folder at runtime in case there's a volume
COPY --chown=steam:steam server_settings/ServerGameSettings.json /home/steam/v-rising/ServerGameSettings.json
COPY --chown=steam:steam server_settings/ServerHostSettings.json /home/steam/v-rising/ServerHostSettings.json
COPY --chown=steam:steam server_settings/adminlist.txt /home/steam/v-rising/adminlist.txt
# Start scripts
COPY --chown=steam:steam scripts/start-server.bash .
RUN chmod +x start-server.bash
CMD [ "./start-server.bash", "default" ]
