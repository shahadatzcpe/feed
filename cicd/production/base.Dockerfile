# ──────────────────────────────
# Stage 1: Base image with system dependencies
# ──────────────────────────────
FROM php:8.2-fpm-alpine AS base

# Install build and runtime dependencies
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
        bash \
        git \
        curl \
        zip \
        unzip \
        zlib \
        libzip \
        libpng \
        libjpeg-turbo \
        freetype \
        libxml2 \
        oniguruma

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# ──────────────────────────────
# Stage 2: Builder (install dependencies)
# ──────────────────────────────
FROM base AS builder

# Copy files required for Composer install
COPY composer.json composer.lock ./
COPY bootstrap/ bootstrap/
COPY routes/ routes/
COPY artisan ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --ignore-platform-req=ext-pcntl

# Optional: remove source files to clean up image
RUN rm -rf bootstrap routes artisan composer.json composer.lock

# ──────────────────────────────
# Stage 3: Final image (reuse builder)
# ──────────────────────────────
FROM builder AS final

WORKDIR /var/www/feed

# Copy only vendor folder from builder
COPY --from=builder /app/vendor /var/www/feed/vendor

EXPOSE 9000
CMD ["php-fpm"]
