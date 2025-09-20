#!/bin/sh

#!/bin/bash

usermod -aG shadow Debian-exim

if ! id "$MAIL_USER" &>/dev/null; then
    echo "Creating PAM user $MAIL_USER..."
    # Create a system user without a home directory (-M) and without a login shell (-s /sbin/nologin)
    useradd -M "$MAIL_USER"

    # Set the password securely by piping it to chpasswd's standard input
    # Avoids exposing the password in the process list
    echo "$MAIL_USER:$MAIL_PASSWORD" | chpasswd

    # Check if the user creation was successful
    if [ $? -eq 0 ]; then
        echo "PAM user $MAIL_USER created successfully."
    
    else
        echo "Error creating user $MAIL_USER."
        exit 1
    fi
else
    echo "PAM user $MAIL_USER already exists."
fi

# --- Ensure config ownership/permissions
chown root:Debian-exim /etc/exim4/exim4.conf
chmod 644 /etc/exim4/exim4.conf

chown root:Debian-exim /etc/exim4/auth/username.id
chown root:Debian-exim /etc/exim4/auth/password.key
chmod 644 /etc/exim4/auth/username.id
chmod 644 /etc/exim4/auth/password.key

# --- Helper function to copy if changed
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

# --- Check/update cert and key
copy_if_changed /certs/exim.key /home/exim/certs/exim.key
copy_if_changed /certs/exim.crt /home/exim/certs/exim.crt

# --- Start Exim
exim4 -bd -q15m -v
