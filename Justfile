#!/usr/bin/env -S just --justfile

# Copy quadlet directory to host and refresh units
push-quadlet dir host='shipyard.lan':
    scp -r "containers/{{ dir }}" '{{ host }}:.config/containers/systemd'
    ssh {{ host }} systemctl --user daemon-reload

# Bulk update Debian hosts
[working-directory('ansible')]
update-debservers:
    @echo '{{ CYAN }}Updating Debian hosts...{{ NORMAL }}'
    ansible debserver --inventory hosts.ini --user root --forks 8 -m apt -a \
        'update_cache=yes upgrade=yes autoclean=true autoremove=true'
