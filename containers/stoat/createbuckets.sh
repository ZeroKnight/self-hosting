#!/bin/sh

# Ensure we have a writeable HOME
export HOME=/tmp

while ! /usr/bin/mc ready silo; do
    echo 'Waiting for silo...' && sleep 1
    /usr/bin/mc alias set silo http://localhost:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
done
/usr/bin/mc mb --ignore-existing --region minio silo/revolt-uploads
