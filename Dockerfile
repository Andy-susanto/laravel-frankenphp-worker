FROM dunglas/frankenphp:1.2.0-alpine

WORKDIR /app

COPY . /app

RUN apk add --no-cache \
    zip \
    libzip-dev \
    curl \
    supervisor && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip  && \
    docker-php-ext-install pcntl && \
    mkdir -p /var/log/supervisor /var/run

COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

RUN composer install --no-dev --optimize-autoloader && \
    chmod -R 775 storage bootstrap/cache

RUN php artisan octane:install --server=frankenphp

# Copy konfigurasi Supervisor
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 3000

# Gunakan ENTRYPOINT dan CMD untuk menjalankan supervisor
# ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

CMD ["php", "artisan", "octane:start", "--server=frankenphp", "--host=http://uggg8o44ggw4cwgsk8wo4k88.151.106.112.156.sslip.io", "--port=3000","--admin-port=8080"]
