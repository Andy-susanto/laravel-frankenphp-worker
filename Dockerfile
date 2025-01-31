FROM php:8.2-fpm

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    unzip \
    git

RUN docker-php-ext-install gd pdo pdo_mysql zip

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

COPY composer.json composer.lock ./

RUN composer install --no-dev --optimize-autoloader && \
    chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data /app

# Cache configuration dan routes
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# RUN php artisan octane:install --server=frankenphp

# Copy konfigurasi Supervisor
# COPY supervisord.conf /etc/supervisord.conf

# Copy the default FrankenPHP config
# COPY .frankenphp.php /app/.frankenphp.php

# COPY Caddyfile /etc/caddy/Caddyfile

CMD ["frankenphp", "run", "--host", "0.0.0.0"]


EXPOSE 3000

CMD ["php-fpm"]

# Gunakan ENTRYPOINT dan CMD untuk menjalankan supervisor
# ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# ENTRYPOINT ["php", "artisan", "octane:frankenphp","--port=3000","--admin-port=8080" , "--host=0.0.0.0"]

# Add healthcheck
# HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
#     CMD curl -f http://localhost:3000/health || exit 1

# CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=0.0.0.0","--admin-port=8080"]
