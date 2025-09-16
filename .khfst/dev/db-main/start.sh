#!/bin/bash
set -e

cp /home/postgres/raw-certs/* /home/postgres/certs/
chown postgres:postgres /home/postgres/certs/*
chmod 600 /home/postgres/certs/*.key
chmod 644 /home/postgres/certs/*.crt

export POSTGRES_DB=$MAIN_DB_NAME
export POSTGRES_USER=$MAIN_DB_USER
export POSTGRES_PASSWORD=$MAIN_DB_PASSWORD

# Start postgres in background
docker-entrypoint.sh postgres \
  -c ssl=on \
  -c ssl_cert_file=/home/postgres/certs/db-main.crt \
  -c ssl_key_file=/home/postgres/certs/db-main.key \
  -c ssl_ca_file=/home/postgres/certs/ca.crt 