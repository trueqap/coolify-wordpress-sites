FROM dunglas/frankenphp:php8.3-alpine

# Install dependencies and extensions
RUN install-php-extensions \
    opcache \
    redis \
    intl \
    mysqli \
    gd \
    zip \
    exif

# Install WordPress
ENV WORDPRESS_VERSION 6.7.1
ENV WORDPRESS_SHA1 1234567890abcdef1234567890abcdef12345678 
# Note: SHA1 is placeholder, usually we download latest or specific version. 
# Using a simpler approach to download latest WP.

RUN curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz" \
    && tar -xzf wordpress.tar.gz -C /app/public --strip-components=1 \
    && rm wordpress.tar.gz \
    && chown -R www-data:www-data /app/public

# Copy Configs
COPY Caddyfile /etc/frankenphp/Caddyfile
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /app/public

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["frankenphp", "run", "--config", "/etc/frankenphp/Caddyfile"]
