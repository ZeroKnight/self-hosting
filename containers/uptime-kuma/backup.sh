#!/bin/sh

set -eu

backup_dir='/backup/volumes/uptime-kuma'
[ -d "$backup_dir" ] || mkdir -p "$backup_dir"

sqlite3 /data/kuma.db ".backup main $backup_dir/kuma.db"

rsync -avv --delete --exclude 'kuma.db*' /data/ "$backup_dir"
