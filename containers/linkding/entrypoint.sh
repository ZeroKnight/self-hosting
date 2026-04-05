#!/usr/bin/env bash

export LD_SERVER_HOST="${LD_SERVER_HOST:-[::]}"
export LD_SERVER_PORT="${LD_SERVER_PORT:-9090}"

mkdir -p data/{favicons,previews,assets}

# Remove hard-coded uid/gid
sed -i '/[ug]id\s*=/d' /etc/linkding/uwsgi.ini

for name in generate_secret_key migrate enable_wal create_initial_superuser migrate_tasks; do
    python manage.py "$name"
done

exec uwsgi --http "$LD_SERVER_HOST:$LD_SERVER_PORT" uwsgi.ini
