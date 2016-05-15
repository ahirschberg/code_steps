#!/bin/bash

srvbuild() {
    pushd build/web/
    python -m SimpleHTTPServer
    popd
}

startdart() {
    DART_FLAGS='--checked' ~/Downloads/dartium-lucid64-full-stable-1.16.0.0/chrome --no-sandbox --user-data-dir=/home/alex/.WebStorm2016.1/config/chrome-user-data localhost:8080
}

if [ "$1" != "-b" ]; then # if -b passed, only bind
    startdart &
fi
