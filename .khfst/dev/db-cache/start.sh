#!/bin/bash
set -e

# --- setup certificates
cp /home/postgres/raw-certs/* /home/postgres/certs/
chown postgres:postgres /home/postgres/certs/*
chmod 600 /home/postgres/certs/*.key
chmod 644 /home/postgres/certs/*.crt

# --- setup environment variables
export POSTGRES_DB=$DB_CACHE_NAME
export POSTGRES_USER=$DB_CACHE_USER
export POSTGRES_PASSWORD=$DB_CACHE_PASSWORD

# --- setup postgres
docker-entrypoint.sh postgres \
  -c ssl=on \
  -c ssl_cert_file=/home/postgres/certs/db-main.crt \
  -c ssl_key_file=/home/postgres/certs/db-main.key \
  -c ssl_ca_file=/home/postgres/certs/ca.crt 