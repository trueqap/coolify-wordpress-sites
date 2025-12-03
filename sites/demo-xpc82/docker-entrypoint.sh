#!/bin/sh
set -e

# Fix ownership of /app/public for www-data
chown -R www-data:www-data /app/public

# Create wp-config.php if it doesn't exist
if [ ! -f /app/public/wp-config.php ]; then
    cat > /app/public/wp-config.php << 'WPCONFIG'
<?php
// HTTPS behind reverse proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

define('WP_HOME', 'https://demo-xpc82.hellowp.cloud');
define('WP_SITEURL', 'https://demo-xpc82.hellowp.cloud');
define('FORCE_SSL_ADMIN', true);

define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'wordpress');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: '');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mariadb');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// Redis
define('WP_REDIS_HOST', 'redis');
define('WP_REDIS_PORT', 6379);
define('WP_REDIS_DATABASE', 0);
define('WP_REDIS_TIMEOUT', 1);
define('WP_REDIS_READ_TIMEOUT', 1);
define('WP_CACHE', true);

// Performance
define('WP_MEMORY_LIMIT', '1024M');
define('WP_MAX_MEMORY_LIMIT', '1024M');
define('DISABLE_WP_CRON', false);
define('WP_POST_REVISIONS', 5);
define('AUTOSAVE_INTERVAL', 120);
define('EMPTY_TRASH_DAYS', 14);
define('CONCATENATE_SCRIPTS', false);
define('COMPRESS_SCRIPTS', true);
define('COMPRESS_CSS', true);

// Authentication keys - generate unique ones at https://api.wordpress.org/secret-key/1.1/salt/
define('AUTH_KEY',         getenv('AUTH_KEY') ?: 'put-your-unique-phrase-here');
define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY') ?: 'put-your-unique-phrase-here');
define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY') ?: 'put-your-unique-phrase-here');
define('NONCE_KEY',        getenv('NONCE_KEY') ?: 'put-your-unique-phrase-here');
define('AUTH_SALT',        getenv('AUTH_SALT') ?: 'put-your-unique-phrase-here');
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT') ?: 'put-your-unique-phrase-here');
define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT') ?: 'put-your-unique-phrase-here');
define('NONCE_SALT',       getenv('NONCE_SALT') ?: 'put-your-unique-phrase-here');

$table_prefix = 'wp_';

define('WP_DEBUG', false);

// Filesystem - direct write without FTP
define('FS_METHOD', 'direct');

if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
WPCONFIG
    chown www-data:www-data /app/public/wp-config.php
    echo "wp-config.php created"
fi

# Execute the main command
exec "$@"
