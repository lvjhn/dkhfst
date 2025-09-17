#!/bin/bash
set -euo pipefail

source .env

# --- set up certificates directory
echo ":: Setting up certificates directory."
CERTS_DIR="./.khfst/dev/@certs"
mkdir -p "$CERTS_DIR"

# --- copy root CA 
echo ":: Copying root CA certificate."
CAROOT=$(mkcert -CAROOT)
cp "$CAROOT/rootCA.pem" "$CERTS_DIR/ca.crt"
cp "$CAROOT/rootCA-key.pem" "$CERTS_DIR/ca.key"

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
issue_certificate db-main           db-main 
issue_certificate db-main           db-cache 
issue_certificate db-queue          db-queue 

# --- ENDPOINTS --- # 
issue_certificate frontend-web      m.${PROJECT_NAME}.local 
issue_certificate frontend-mobile   ${PROJECT_NAME}.local 
issue_certificate http-api          api.${PROJECT_NAME}.local 
issue_certificate ws-api            realtime.${PROJECT_NAME}.local

# --- TOOLS --- # 
issue_certificate pgadmin           pgadmin.${PROJECT_NAME}.local 
issue_certificate mailpit           mailpit.${PROJECT_NAME}.local
issue_certificate adminer           adminer.${PROJECT_NAME}.local 

echo "✅ All certificates generated."
