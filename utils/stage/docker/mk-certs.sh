#!/bin/bash
set -euo pipefail

source .env

# --- set up certificates directory
echo ":: Setting up certificates directory."
CERTS_DIR="./.dkhfst/docker/stage/@certs"
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
issue_certificate db-main           db-main  ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}
issue_certificate db-cache          db-cache ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}
issue_certificate db-queue          db-queue ${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}

# --- ENDPOINTS --- # 
issue_certificate frontend-web      "${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}" "*.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}"
issue_certificate frontend-mobile   m.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE} 
issue_certificate http-api          api.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE} 
issue_certificate ws-api            realtime.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}

# --- TOOLS --- # 
issue_certificate postfix           postfix.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}
issue_certificate mailpit           mailpit.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE}
issue_certificate adminer           adminer.${PROJECT_DOMAIN_NAME}${PROJECT_DOMAIN_EXT_STAGE} 

echo "✅ All certificates generated."
