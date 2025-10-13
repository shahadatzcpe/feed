# Use base image with PHP + dependencies already installed
FROM 463470945909.dkr.ecr.eu-west-2.amazonaws.com/syncastor/feed/production/base:latest

WORKDIR /var/www

# Copy Laravel app code only
COPY . .

# Set permissions for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose PHP-FPM port (optional)
EXPOSE 9000

# CMD is optional; deployment can define it
# CMD ["php-fpm"]
