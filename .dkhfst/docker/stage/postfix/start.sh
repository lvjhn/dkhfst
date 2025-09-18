#!/bin/sh
set -e

echo ":: In relay mode.."

# -----------------------------
# 1. Hostname and domain
# -----------------------------
postconf -e "myhostname = ${HOSTNAME:-mail.local}"
postconf -e "mydomain = ${MAIL_DOMAIN:-localhost}"
postconf -e "myorigin = \$mydomain"

# -----------------------------
# 2. Restrict networks and relay
# -----------------------------
postconf -e "mynetworks = 127.0.0.0/8, 0.0.0.0/0"
postconf -e "relayhost = [mailpit]:1025"

# Disable local delivery checks
postconf -e "local_recipient_maps="
postconf -e "virtual_alias_maps="

# -----------------------------
# 3. Optional TLS (for dev testing)
# -----------------------------
if [ -d "/certs" ]; then
  postconf -e "smtp_tls_security_level = may"
  postconf -e "smtp_tls_cert_file = /certs/postfix.crt"
  postconf -e "smtp_tls_key_file = /certs/postfix.key"
  postconf -e "smtp_tls_CAfile = /certs/ca.crt"
fi

# -----------------------------
# 4. Reload Postfix to apply configuration
# -----------------------------
postfix reload || true

# -----------------------------
# 5. Start Postfix in foreground
# -----------------------------
exec postfix start-fg
