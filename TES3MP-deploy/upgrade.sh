#!/bin/bash

#NUMBER OF CPU CORES USED FOR COMPILATION
CORES=5

#DISTRO IDENTIFICATION
DISTO="$(lsb_release -si)"

#FOLDER HIERARCHY
BASE="$(pwd)"
CODE=$BASE/code
DEVELOPMENT=$BASE/build
KEEPERS=$BASE/keepers
DEPENDENCIES=$BASE/dependencies

#LOCATIONS OF RAKNET AND TERRA
RAKNET_LOCATION="$DEPENDENCIES/raknet"
TERRA_LOCATION="$DEPENDENCIES/terra"

cd $CODE
git pull
cd $BASE

#OPTION TO UPGRADE AFTER PULLING THE CHANGES FROM THE GIT REPOSITORY
if [ "$1" = "--install" ]; then
  UPGRADE="YES"
else
  echo "Upgrade?"
  read UPGRADE
fi

#REBUILD OPENMW/TES3MP
if [ "$UPGRADE" = "YES" ]; then

  rm -r $DEVELOPMENT
  mkdir $DEVELOPMENT

  cd $DEVELOPMENT
  cmake $CODE -DBUILD_OPENCS=OFF -DRakNet_INCLUDES=${RAKNET_LOCATION}/include/RakNet -DRakNet_LIBRARY_DEBUG=${RAKNET_LOCATION}/build/Lib/LibStatic/libRakNetLibStatic.a -DRakNet_LIBRARY_RELEASE=${RAKNET_LOCATION}/build/Lib/LibStatic/libRakNetLibStatic.a -DTerra_LIBRARY_RELEASE=${TERRA_LOCATION}/lib/libterra.a -DTerra_INCLUDES=${TERRA_LOCATION}/include
  make -j $CORES

fi

#CREATE SYMLINKS FOR THE CONFIG FILES INSIDE THE NEW BUILD FOLDER
for file in $KEEPERS/*
do
  FILEPATH=$file
  FILENAME=$(basename $file)
    mv "$DEVELOPMENT/$FILENAME" "$DEVELOPMENT/$FILENAME.bkp" 2> /dev/null
    ln -s "$KEEPERS/$FILENAME" "$DEVELOPMENT/"
done

read
