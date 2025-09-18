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
issue_certificate db-main           db-main  db-main.${PROJECT_NAME}.test
issue_certificate db-main           db-cache db-cache.${PROJECT_NAME}.test
issue_certificate db-queue          db-queue db-queue.${PROJECT_NAME}.test

# --- ENDPOINTS --- # 
issue_certificate frontend-web      "${PROJECT_NAME}.test" "*.${PROJECT_NAME}.test"
issue_certificate frontend-mobile   m.${PROJECT_NAME}.test 
issue_certificate http-api          api.${PROJECT_NAME}.test 
issue_certificate ws-api            realtime.${PROJECT_NAME}.test

# --- TOOLS --- # 
issue_certificate postfix           postfix.${PROJECT_NAME}.test
issue_certificate adminer           adminer.${PROJECT_NAME}.test 

echo "✅ All certificates generated."
