#!/bin/bash 
source ./.dkhfst/py-env/bin/activate
python3 -m utils.prod.docker.helpers.mail_test $@