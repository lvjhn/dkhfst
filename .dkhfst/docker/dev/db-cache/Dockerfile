ARG DB_CACHE_VERSION

# --- load PostgresSQL image
FROM $DB_CACHE_VERSION

# --- switch to root user 
USER root

# --- create certificates directory
RUN mkdir -p /home/postgres/certs

# --- set up permissions
RUN chown -R postgres:postgres /home/postgres/certs 
RUN chmod 700 /home/postgres/certs

# --- switch back to postgres user
USER postgres

# --- set up working directory
WORKDIR /home/postgres

