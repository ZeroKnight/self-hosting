#!/bin/sh

set -eu

backup_dir='/backup/volumes/upsnap'
[ -d "$backup_dir" ] || mkdir -p "$backup_dir"

sqlite3 /data/data.db ".backup main $backup_dir/data.db"
sqlite3 /data/auxiliary.db ".backup main $backup_dir/auxiliary.db"

rsync -avv --delete /data/storage "$backup_dir"
