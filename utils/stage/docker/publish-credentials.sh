#!/bin/bash 
source .env

rm -rf 

# --- publish Exim credentials
echo ":: Publishing Exim credentials ($MAIL_USER:$MAIL_PASSWORD)."
rm -rf ./.dkhfst/docker/stage/exim/auth/
mkdir -p ./.dkhfst/docker/stage/exim/auth/
echo -n "$MAIL_USER" > ./.dkhfst/docker/stage/exim/auth/username.id
echo -n "$MAIL_PASSWORD" > ./.dkhfst/docker/stage/exim/auth/password.key

# --- done 
echo "DONE"