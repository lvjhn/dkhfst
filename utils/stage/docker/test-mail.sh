#!/bin/bash 
source ./.dkhfst/py-env/bin/activate
python3 -m utils.stage.docker.helpers.mail_test $@