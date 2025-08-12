FROM dunglas/frankenphp:1-php8.3-alpine

RUN apk add --no-cache \
    git \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libxml2-dev \
    oniguruma-dev \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY docker/php/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]

EXPOSE 80

CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0", "--port=80", "--admin-port=2019"]
