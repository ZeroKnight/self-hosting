#!/bin/sh

set -eu

backup_dir='/backup/volumes/lubelogger'

# Tell LubeLogger to generate a backup
backup=$(
    curl --no-progress-meter -H "X-API-Key: $LUBELOGGER_APIKEY" \
        "http://localhost:$LUBELOGGER_PORT/api/makebackup" |
        tr -d '"'
)

if [ -d "$backup_dir/data" ]; then
    # Clear previous backup contents first
    rm -rf "$backup_dir/data"/*
else
    mkdir -p "$backup_dir/data"
fi

unzip "/data$backup" -d "$backup_dir/data"

# LubeLogger won't remove these later, so remove it now
rm "/data$backup"

# I actually don't know if these are important for restoration, but meh
rsync -avv --delete /keys/ "$backup_dir/keys"
