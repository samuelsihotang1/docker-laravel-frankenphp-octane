#!/bin/sh
set -e

cd /var/www/html

if [ ! -f "composer.json" ]; then
    composer create-project laravel/laravel .
fi

if [ ! -f .env ]; then
    cp .env.example .env
fi

if ! grep -q "^APP_KEY=." .env; then
    php artisan key:generate
fi

sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=${DB_CONNECTION}/" .env
sed -i "s/^#* *DB_HOST=.*/DB_HOST=${DB_HOST}/" .env
sed -i "s/^#* *DB_PORT=.*/DB_PORT=${DB_PORT:-3306}/" .env
sed -i "s/^#* *DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" .env
sed -i "s/^#* *DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" .env
sed -i "s/^#* *DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" .env

chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

composer install --optimize-autoloader --no-interaction --no-progress

if ! grep -q "laravel/octane" composer.json; then
    composer require laravel/octane --no-interaction --no-progress
fi
php artisan octane:install --server=frankenphp

php artisan migrate --force

if [ -z "$APP_ENV" ]; then
    APP_ENV=$(grep ^APP_ENV= .env | cut -d '=' -f2 | tr -d '\r')
fi

if [ "$APP_ENV" = "production" ]; then
    php artisan config:clear
    php artisan view:clear
    php artisan route:clear
    
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
else
    php artisan config:clear
    php artisan view:clear
    php artisan route:clear
fi

exec "$@"