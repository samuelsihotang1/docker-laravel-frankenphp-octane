FROM dunglas/frankenphp:1-php8.3-alpine

RUN apk add --no-cache \
    dos2unix \
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
RUN dos2unix /usr/local/bin/init.sh && \
    chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]

EXPOSE 80