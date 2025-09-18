# 
# FIRST TIME SET-UP SCRIPT
# 
source .env
source .dkhfst/docker/stage/.env

function uncreate_containers() {
    bash docker-compose down -v 
}

function make_certificates() {
    echo ":: Creating SSL certificates."
    bash utils/stage/docker/mk-certs.sh
} 

function create_containers() {
    echo ":: Creating containers." 
    bash docker-compose create 
}

function wait_for_db() {
    bash docker-compose exec $1 sh -c '
        until pg_isready; 
            do sleep 2; 
        done
    '
}

function run_migrations() {
    bash docker-compose up -d db-main
    bash docker-compose up -d db-queue
    bash docker-compose up -d db-cache
    
    wait_for_db db-main
    wait_for_db db-queue 
    wait_for_db db-cache

    bash docker-compose up -d backend 
    bash docker-compose exec --user root backend php artisan migrate
    bash docker-compose stop backend
}   

function start_containers() {
    echo ":: Starting containers."
    bash docker-compose up
}

function main() {
    uncreate_containers
    make_certificates
    create_containers
    run_migrations
    start_containers
}

main