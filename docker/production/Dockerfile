# Stage 1: Composer dependencies
FROM composer:2 AS vendor
WORKDIR /app

# Copy dependency files for caching
COPY composer.json composer.lock ./

# Copy minimal app code needed for Laravel discovery
COPY app/ app/
COPY config/ config/
COPY routes/ routes/
COPY artisan ./

# Install production dependencies and run Laravel package discovery
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist \
    && php artisan package:discover

# Stage 2: PHP-FPM production image
FROM php:8.2-fpm-alpine

# Install system dependencies (lightweight Alpine)
RUN apk add --no-cache \
    libpng libjpeg-turbo freetype libxml2 oniguruma \
    zip unzip git curl \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Set working directory
WORKDIR /var/www/feed

# Copy vendor from the previous stage
COPY --from=vendor /app/vendor /var/www/feed/vendor

# Copy application code
COPY . .

# Ensure storage directory exists with correct permissions
RUN mkdir -p /var/www/feed/storage/shared \
 && chown -R www-data:www-data /var/www/feed/storage \
 && chmod -R 775 /var/www/feed/storage

# Expose PHP-FPM port
EXPOSE 9000

# Default command
CMD ["php-fpm"]
