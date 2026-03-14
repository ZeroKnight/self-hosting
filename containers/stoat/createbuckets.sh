#!/bin/sh

while ! /usr/bin/mc ready minio; do
    /usr/bin/mc alias set minio http://localhost:9000 "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
    echo 'Waiting for minio...' && sleep 1
done

/usr/bin/mc mb minio/revolt-uploads

exit 0
