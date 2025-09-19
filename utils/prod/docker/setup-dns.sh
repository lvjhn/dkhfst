#!/bin/bash
set -e

# --- Load environment variables ---
if [ ! -f .env ]; then
    echo "❌ .env file not found!"
    exit 1
fi
source .env

# --- Activate Python virtual environment ---
if [ ! -d ./.dkhfst/py-env ]; then
    echo "❌ Python virtual environment not found!"
    exit 1
fi
source ./.dkhfst/py-env/bin/activate

# --- Generate new DNS config to a temporary file ---
DNS_OUTPUT_DIR="./.dkhfst/dns"
mkdir -p "$DNS_OUTPUT_DIR"
DNS_CONF="$DNS_OUTPUT_DIR/dkhfst-dp.${PROJECT_NAME}.conf"
TMP_CONF="$DNS_CONF.tmp"

echo "🔧 Generating DNS config..."
python3 -m utils.prod.docker.helpers.setup_dns > "$TMP_CONF"

# --- Compare checksums ---
UPDATE_NEEDED=false
if [ -f "$DNS_CONF" ]; then
    OLD_SUM=$(md5sum "$DNS_CONF" | awk '{print $1}')
    NEW_SUM=$(md5sum "$TMP_CONF" | awk '{print $1}')
    if [ "$OLD_SUM" != "$NEW_SUM" ]; then
        UPDATE_NEEDED=true
        echo "ℹ️ DNS config has changed, updating..."
    else
        echo "✅ DNS config unchanged, no update needed."
    fi
else
    UPDATE_NEEDED=true
    echo "ℹ️ DNS config does not exist, creating..."
fi

# --- Replace old config only if changed ---
if [ "$UPDATE_NEEDED" = true ]; then
    mv "$TMP_CONF" "$DNS_CONF"
else
    rm "$TMP_CONF"
fi

# --- Symlink to /etc/dnsmasq.d ---
DNSMASQ_DIR="/etc/dnsmasq.d"
mkdir -p "$DNSMASQ_DIR"
SYMLINK_TARGET="$DNSMASQ_DIR/dkhfst-dp.${PROJECT_NAME}.conf"

if [ ! -L "$SYMLINK_TARGET" ] || [ "$UPDATE_NEEDED" = true ]; then
    sudo ln -sf "$(pwd)/$DNS_CONF" "$SYMLINK_TARGET"
    echo "✅ Symlink updated: $SYMLINK_TARGET"
else
    echo "ℹ️ Symlink unchanged."
fi

# --- Reload or start dnsmasq only if update occurred ---
if [ "$UPDATE_NEEDED" = true ]; then
    if systemctl is-active --quiet dnsmasq; then
        echo "🔄 Reloading dnsmasq..."
        sudo systemctl restart dnsmasq
    else
        echo "🔄 Starting dnsmasq..."
        sudo systemctl start dnsmasq
    fi
else
    echo "ℹ️ dnsmasq reload not needed."
fi

echo "✅ dnsmasq update complete for project: $PROJECT_NAME"
