
FROM mcr.microsoft.com/windows:1909

SHELL ["powershell"]
ENV POWERSHELL_TELEMETRY_OPTOUT 1
# ENV HOME "c:\steamcmd"


RUN New-LocalUser -Name "steamps" -NoPassword -AccountNeverExpires -UserMayNotChangePassword | Set-LocalUser -PasswordNeverExpires $true
USER steamps

RUN Install-Module -Name SteamPS -Scope CurrentUse

# Create SteamCMD directory
# RUN New-Item -ItemType Directory "c:\steamcmd"

# # Set SteamCMD working directory
# WORKDIR $HOME

# # Download and unpack SteamCMD archive
# RUN Invoke-WebRequest http://media.steampowered.com/installer/steamcmd.zip -O c:\steamcmd\steamcmd.zip; \
#     Expand-Archive c:\steamcmd\steamcmd.zip -DestinationPath c:\steamcmd; \
#     Remove-Item c:\steamcmd\steamcmd.zip

# # Update SteamCMD
# RUN c:\steamcmd\steamcmd.exe +quit; exit 0

# # Set default command
# ENTRYPOINT c:\steamcmd\steamcmd.exe
# CMD +help +quit