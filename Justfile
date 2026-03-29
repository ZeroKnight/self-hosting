#!/usr/bin/env -S just --justfile

# Bulk update Debian hosts
[working-directory('ansible')]
update-debservers:
    @echo '{{ CYAN }}Updating Debian hosts...{{ NORMAL }}'
    ansible debserver --inventory hosts.ini --user root --forks 8 -m apt -a \
        'update_cache=yes upgrade=yes autoclean=true autoremove=true'

# Copy quadlet directory to host and refresh units
[group('podman')]
push-quadlet dir host='shipyard.lan':
    scp -r "containers/{{ dir }}" '{{ host }}:.config/containers/systemd'
    ssh {{ host }} systemctl --user daemon-reload

# Create Podman secret on container host
[group('podman')]
create-secret name host='shipyard.lan':
    #!/bin/bash
    read -s -p 'Secret value: ' secret
    echo
    echo -n "$secret" | ssh '{{ host }}' podman secret create '{{ name }}' -
