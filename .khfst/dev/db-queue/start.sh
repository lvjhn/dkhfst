#!/bin/bash
set -e

# --- setup certificates
cp /home/postgres/raw-certs/* /home/postgres/certs/
chown postgres:postgres /home/postgres/certs/*
chmod 600 /home/postgres/certs/*.key
chmod 644 /home/postgres/certs/*.crt

# --- setup environment variables
export POSTGRES_DB=$QUEUE_DB_NAME
export POSTGRES_USER=$QUEUE_DB_USER
export POSTGRES_PASSWORD=$QUEUE_DB_PASSWORD

# --- start postgres
docker-entrypoint.sh postgres \
  -c ssl=on \
  -c ssl_cert_file=/home/postgres/certs/db-queue.crt \
  -c ssl_key_file=/home/postgres/certs/db-queue.key \
  -c ssl_ca_file=/home/postgres/certs/ca.crt 