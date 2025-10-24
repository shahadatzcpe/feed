# ──────────────────────────────
# Stage 1: Base image with system dependencies (Runtime Only)
# ──────────────────────────────
FROM php:8.2-fpm-alpine AS base

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libxml2-dev \
        oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps \
    && apk add --no-cache \
        zlib \
        libzip \
        libpng \
        libjpeg-turbo \
        freetype \
        libxml2 \
        oniguruma

# No Composer copied here
WORKDIR /var/www/feed

EXPOSE 9000
CMD ["php-fpm"]
