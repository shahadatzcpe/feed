# ──────────────────────────────
# Stage 1: Base image with system dependencies
# ──────────────────────────────
FROM php:8.2-fpm-alpine AS base

# Install system dependencies & PHP extensions
RUN apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS zlib-dev libzip-dev libpng-dev libjpeg-turbo-dev freetype-dev libxml2-dev oniguruma-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps \
    && apk add --no-cache bash git curl zip unzip zlib libzip libpng libjpeg-turbo freetype libxml2 oniguruma

WORKDIR /var/www/feed

# ──────────────────────────────
# Stage 2: Vendor dependencies
# ──────────────────────────────
FROM composer:2 AS vendor

WORKDIR /app

# Copy only composer files to leverage cache
COPY composer.json composer.lock ./
COPY bootstrap/ bootstrap/
COPY routes/ routes/
COPY artisan ./

# Install production dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-req=ext-pcntl

# ──────────────────────────────
# Stage 3: Application code
# ──────────────────────────────
FROM base AS final

WORKDIR /var/www/feed

# Copy vendor from previous stage
COPY --from=vendor /app/vendor /var/www/feed/vendor

# Copy full application code
COPY . /var/www/feed

# Set permissions
RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data . \
    && chmod -R 775 storage bootstrap/cache

EXPOSE 9000

USER www-data
CMD ["php-fpm"]
