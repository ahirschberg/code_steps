#!/bin/bash
# Starts a build of chromium with the Dart VM enabled in checked mode
# You can define these env vars in your .bashrc or set them in this file directly
[ -z $DARTIUM_BIN ] && (>&2 echo -e "\e[31mERROR: No dartium binary set. Use the env var DARTIUM_BIN.\e[39m"; exit 1)

[ -z $DARTIUM_USER_DATA_DIR ] && >&2 echo -e "\e[31mWARNING: Dartium launched by this script may not function correctly without the DARTIUM_USER_DATA_DIR environment variable set.\e[39m"

DART_FLAGS='--checked' $DARTIUM_BIN --no-sandbox --user-data-dir=$DARTIUM_USER_DATA_DIR localhost:8080 &
