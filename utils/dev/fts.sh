# 
# FIRST TIME SET-UP SCRIPT
# 
source .env
source .khfst/$PROJECT_MODE/.env

function uncreate_containers() {
    bash docker-compose down -v
}

function clear_certain_folders() {
    echo ":: Clearing certain folders."
    sudo rm -rf ./source/backend/vendor/*
    sudo rm -rf ./source/frontend-web/node_modules/* 
    sudo rm -rf ./source/frontend-mobile/node_modules/*
}

function make_certificates() {
    echo ":: Creating SSL certificates."
    bash utils/dev/mk-certs.sh
} 

function create_containers() {
    echo ":: Creating containers." 
    bash docker-compose create 
}

function start_containers() {
    echo ":: Start containers."
    bash docker-compose up
}

function main() {
    uncreate_containers
    clear_certain_folders
    make_certificates
    create_containers
    start_containers
}

main