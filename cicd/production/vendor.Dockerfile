FROM 463470945909.dkr.ecr.eu-west-2.amazonaws.com/syncastor/feed/production:latest-base

WORKDIR /var/www/feed

# Copy composer binary from official composer:2 image
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Copy entire source code
COPY . .

# Install PHP dependencies
RUN export COMPOSER_MEMORY_LIMIT=-1 \
    && composer install \
        --no-dev \
        --optimize-autoloader \
        --no-interaction \
        --ignore-platform-reqs

# Delete everything except vendor folder
RUN find . -mindepth 1 -maxdepth 1 ! -name 'vendor' -exec rm -rf {} +

WORKDIR /var/www/feed
