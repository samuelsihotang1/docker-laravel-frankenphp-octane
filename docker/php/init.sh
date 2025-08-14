#!/bin/sh
set -e

cd /var/www/html

SETUP_LOCK_FILE="/var/www/html/storage/logs/.setup_complete"

# =================================================================
#  THIS PART WILL ONLY RUN ONCE WHILE THE VOLUME IS STILL EMPTY
# =================================================================
if [ ! -f "$SETUP_LOCK_FILE" ]; then

    if [ ! -f "composer.json" ]; then
        composer create-project laravel/laravel .
    fi

    cp .env.example .env
    php artisan key:generate

    composer install --optimize-autoloader --no-interaction

    composer require laravel/octane --no-interaction
    php artisan octane:install --server=frankenphp

    chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

    sed -i "s/^APP_ENV=.*/APP_ENV=production/" .env
    sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=${DB_CONNECTION}/" .env
    sed -i "s/^#* *DB_HOST=.*/DB_HOST=${DB_HOST}/" .env
    sed -i "s/^#* *DB_PORT=.*/DB_PORT=${DB_PORT}/" .env
    sed -i "s/^#* *DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" .env
    sed -i "s/^#* *DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" .env
    sed -i "s/^#* *DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" .env

    php artisan migrate --force

    touch "$SETUP_LOCK_FILE"

fi

# =================================================================
#  THIS PART WILL RUN EVERY TIME THE CONTAINER IS STARTED 
#  FOR DEVELOPMENT PURPOSES, SET APP_ENV TO "local" IN .env
# =================================================================

APP_ENV=$(grep ^APP_ENV= .env | cut -d '=' -f2 | tr -d '\r')

if [ "$APP_ENV" = "production" ]; then
    php artisan config:cache
    php artisan view:cache
    php artisan route:cache
    exec php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=80 --admin-port=2019
else
    php artisan config:clear
    php artisan view:clear
    php artisan route:clear
    exec php artisan serve --host=0.0.0.0 --port=80
fi