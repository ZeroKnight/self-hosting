#!/usr/bin/env -S just --justfile

# Copy quadlet directory to host and refresh units
push-quadlet dir host='shipyard.lan':
    scp -r "containers/{{ dir }}" '{{ host }}:.config/containers/systemd'
    ssh {{ host }} systemctl --user daemon-reload
