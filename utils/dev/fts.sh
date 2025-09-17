# 
# FIRST TIME SET-UP SCRIPT
# 
source .env
source .khfst/docker/$PROJECT_MODE/.env

function uncreate_containers() {
    bash docker-compose down -v
}

function clear_certain_folders() {
    echo ":: Clearing certain folders."
    sudo rm -rf ./source/backend/vendor/
    sudo rm -rf ./source/frontend-web/node_modules/
    sudo rm -rf ./source/frontend-mobile/node_modules/
    mkdir ./source/backend/vendor/
    mkdir ./source/frontend-web/node_modules/
    mkdir ./source/frontend-mobile/node_modules/
}

function make_certificates() {
    echo ":: Creating SSL certificates."
    bash utils/dev/mk-certs.sh
} 

function create_containers() {
    echo ":: Creating containers." 
    bash docker-compose create 
}


function install_dependencies() {
    echo ":: Installing backend dependencies." 
    bash docker-compose up -d backend 
    bash docker-compose exec --user root backend composer install
    bash docker-compose exec --user root backend php artisan key:generate
    bash docker-compose stop backend

    echo ":: Installing frontend (web) dependencies." 
    bash docker-compose up -d frontend-web
    bash docker-compose exec --user root frontend-web npm install
    bash docker-compose stop frontend-web

    echo ":: Installing frontend (mobile) dependencies." 
    bash docker-compose up -d frontend-mobile
    bash docker-compose exec --user root frontend-mobile npm install
    bash docker-compose stop frontend-mobile
}

function fix_permissions() {
    echo ":: Fixing permissions in backend." 
    bash docker-compose up -d backend 
    bash docker-compose exec --user root backend \
        chown -R www-data:www-data ./storage ./bootstrap/cache ./vendor
    bash docker-compose exec --user root backend \
        chmod -R 775 ./storage ./bootstrap/cache ./vendor
    bash docker-compose exec --user root backend composer install
}

function wait_for_db() {
    sudo docker compose exec $1 sh -c '
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
    clear_certain_folders
    make_certificates
    create_containers
    install_dependencies
    fix_permissions
    run_migrations
    start_containers
}

main