#!/bin/bash
set -euo pipefail

source .env

# --- set up certificates directory
echo ":: Setting up certificates directory."
CERTS_DIR="./.dkhfst/docker/prod/@certs"
sudo rm -rf $CERTS_DIR
mkdir -p "$CERTS_DIR"

# --- copy root CA 
echo ":: Copying root CA certificate."
CAROOT=$(mkcert -CAROOT)
sudo cp "$CAROOT/rootCA.pem" "$CERTS_DIR/ca.crt"
sudo cp "$CAROOT/rootCA-key.pem" "$CERTS_DIR/ca.key"

# --- function to issue certificates ---
function issue_certificate() {
    local FILE_NAME=$1
    shift
    local DOMAINS=("$@")

    echo ":: Issuing certificate for $FILE_NAME (${DOMAINS[*]})"
    mkcert -cert-file "$CERTS_DIR/$FILE_NAME.crt" \
           -key-file "$CERTS_DIR/$FILE_NAME.key" \
           "${DOMAINS[@]}"
}

# --- DATABASES --- #
issue_certificate db-main           db-main  ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}
issue_certificate db-cache          db-cache ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}
issue_certificate db-queue          db-queue ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}

# --- ENDPOINTS --- # 
issue_certificate frontend-web      frontend-web frontend-web-server "${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}" "*.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}"
issue_certificate frontend-mobile   frontend-mobile frontend-mobile-server "m.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}" "*.m.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}"
issue_certificate http-api          backend backend-server api.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD} 
issue_certificate ws-api            websockets websockets-server realtime.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}

# --- TOOLS --- # 
issue_certificate mailpit           mailpit mailpit-server mailpit.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD}
issue_certificate adminer           adminer adminer-server adminer.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_PROD} 

echo "✅ All certificates generated."
