# ──────────────────────────────
# Stage 1: Composer dependencies
# ──────────────────────────────
FROM composer:2 AS vendor

# Set working directory
WORKDIR /app

# Copy composer files first for caching
COPY composer.json composer.lock ./

# Copy minimal Laravel files required for package discovery
COPY bootstrap/ bootstrap/
COPY artisan ./

# Install production dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist \
    --ignore-platform-req=ext-pcntl;


# ──────────────────────────────
# Stage 2: PHP-FPM production image
# ──────────────────────────────
FROM php:8.2-fpm-alpine

# Install system dependencies & PHP extensions
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        libzip-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libxml2-dev \
        oniguruma-dev \
        bash git curl zip unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps \
    && apk add --no-cache zlib libzip libpng libjpeg-turbo freetype libxml2 oniguruma bash curl zip unzip git

# Set working directory
WORKDIR /var/www/feed

# Copy vendor from build stage FIRST (leverages cache)
COPY --from=vendor /app/vendor /var/www/feed/vendor

# Copy application code (vendor is ignored if .dockerignore exists)
COPY . /var/www/feed

# Ensure correct permissions
RUN mkdir -p /var/www/feed/storage /var/www/feed/bootstrap/cache \
    && chown -R www-data:www-data /var/www/feed \
    && chmod -R 775 /var/www/feed/storage /var/www/feed/bootstrap/cache

# Expose PHP-FPM port
EXPOSE 9000

# Run as non-root
USER www-data

CMD ["php-fpm"]
