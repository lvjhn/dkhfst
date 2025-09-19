#!/bin/sh

# Ensure config ownership/permissions
chown root:Debian-exim /etc/exim4/exim4.conf
chmod 644 /etc/exim4/exim4.conf

# Helper function to copy if changed
copy_if_changed() {
    src="$1"
    dst="$2"

    if [ ! -f "$dst" ] || [ "$(sha256sum "$src" | awk '{print $1}')" != "$(sha256sum "$dst" | awk '{print $1}')" ]; then
        cp "$src" "$dst"
        chmod 777 "$dst"
        echo "Updated $dst"
    else
        echo "$dst is up-to-date"
    fi
}

# Check/update cert and key
copy_if_changed /certs/exim.key /home/exim/certs/exim.key
copy_if_changed /certs/exim.crt /home/exim/certs/exim.crt

# Start Exim
exim4 -bd -q15m -v
