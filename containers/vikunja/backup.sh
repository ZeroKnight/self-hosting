#!/bin/sh

set -eu

backup_dir='/backup/volumes/vikunja'
[ -d "$backup_dir" ] || mkdir -p "$backup_dir"
[ -d "$backup_dir/db" ] || mkdir -p "$backup_dir/db"
[ -d "$backup_dir/files" ] || mkdir -p "$backup_dir/files"

sqlite3 /data/db/vikunja.db ".backup main $backup_dir/db/vikunja.db"

rsync -avv --delete /data/files/ "$backup_dir/files"
