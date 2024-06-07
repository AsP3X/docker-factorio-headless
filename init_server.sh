#!/bin/bash

# Setting up environment
if [ -z "$factorio_version" ]; then
  factorio_version=1.1.107
fi

if [ -z "$factorio_variant" ]; then
  factorio_variant=headless
fi

factorio_install=factorio_${factorio_version}_${factorio_variant}.tar.xz

if [ -z "$factorio_save" ]; then
  factorio_save=savegame
fi

#########################################################################

# Download and prepare
mkdir downloads && cd downloads
if test -e "$factorio_install"; then
    echo "'$factorio_install' file exists."
else
    wget -O ${factorio_install} https://factorio.com/get-download/${factorio_version}/${factorio_variant}/linux64
fi

# Preparing and installing factorio
cd /serverfiles
GAME_DIRECTORY=factorio/bin
if [[ -d "$GAME_DIRECTORY" ]]; then
    echo "Directory $GAME_DIRECTORY found."
else
    tar -xvf /server/downloads/${factorio_install}
fi

# Creating save directory
SAVE_DIRECTORY=factorio/saves
if [[ -d "$SAVE_DIRECTORY" ]]; then
    echo "Directory $SAVE_DIRECTORY found."
else
    mkdir ./factorio/saves
fi

# Create a new world if none was provided
# default world name will be savegame
cd factorio
if test -e "./saves/$factorio_save"; then
    echo "'$factorio_save' file exists."
else
    ./bin/x64/factorio --create ./saves/${factorio_save}.zip

    # Changing permissions for all folder/files
    chown -R factorio:factorio /serverfiles
fi

# Run factorio server
sudo -u factorio ./bin/x64/factorio --start-server ${factorio_save}