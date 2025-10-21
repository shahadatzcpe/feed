FROM 463470945909.dkr.ecr.eu-west-2.amazonaws.com/syncastor/feed/production:base-latest

WORKDIR /var/www/feed

# Copy composer binary from official composer:2 image
COPY --from=463470945909.dkr.ecr.eu-west-2.amazonaws.com/syncastor/feed/production:vendor-latest /var/www/feed/vendor /var/www/feed/vendor

# Copy entire source code
COPY . .

# Set ownership to www-data (PHP-FPM user) and permissions
RUN chown -R www-data:www-data /var/www/feed/storage /var/www/feed/bootstrap/cache \
    && chmod -R 775 /var/www/feed/storage /var/www/feed/bootstrap/cache

WORKDIR /var/www/feed


EXPOSE 9000
CMD ["php-fpm"]
