# ──────────────────────────────
# Stage 1: Base image with system dependencies (Runtime Only)
# ──────────────────────────────
FROM php:8.2-fpm-alpine AS base

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

WORKDIR /app

# ──────────────────────────────
# Stage 2: Builder (Composer + Build Tools Only Here)
# ──────────────────────────────
FROM base AS builder

# Install tools only used for building
RUN apk add --no-cache bash git curl zip unzip


# Copy Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install dependencies
COPY . .
RUN composer install --no-dev --optimize-autoloader --prefer-dist --ignore-platform-reqs

# ──────────────────────────────
# Stage 3: Final image (Runtime Only + Vendor)
# ──────────────────────────────
FROM base AS vendor-base

WORKDIR /app

# Copy vendor only from builder
COPY --from=builder /app/vendor ./vendor

CMD ["php-fpm"]
