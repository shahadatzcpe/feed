# Dockerfile.local
FROM php:8.2-fpm

# Install system dependencies and dev tools
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    zip unzip git curl vim \
 && docker-local-ext-configure gd --with-freetype --with-jpeg \
 && docker-local-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
 && pecl install redis \
 && docker-local-ext-enable redis \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/feed

# Copy composer files for caching dependencies
COPY composer.json composer.lock ./

# Install dev dependencies
RUN composer install --no-interaction --prefer-dist

# Ensure storage directory exists with correct permissions
RUN mkdir -p /var/www/feed/storage/shared \
 && chown -R www-data:www-data /var/www/feed/storage \
 && chmod -R 775 /var/www/feed/storage

# Expose PHP-FPM port
EXPOSE 9000

CMD ["php-fpm"]
