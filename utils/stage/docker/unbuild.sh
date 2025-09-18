#!/bin/bash
source .env 
FULL_NAME=$PROJECT_MODE-$PROJECT_NAME
docker images --format "{{.Repository}}:{{.Tag}}" | \
    grep "^$FULL_NAME" | xargs -r docker rmi -f
