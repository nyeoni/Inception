#!/usr/bin/env sh
# This script is used to initialize the wordpress
# It is called by the wordpress container when it starts

# Exit on error
set -ex

# Create wordpress directory
if [ ! -d /var/www/wordpress ]; then
	# create wordpress directory if not exists
	mkdir -p /var/www/wordpress
	# download latest wordpress to wordpress path
	wp core download --path=/var/www/wordpress
	# create www-data system user if not exists
	adduser -D -S -H -G www-data www-data
	# change ownership of wordpress directory to www-data
	chown -R www-data:www-data /var/www/wordpress
fi

# Create wordpress config file
if [ ! -f /var/www/wordpress/wp-config.php ]; then
	# create wordpress config file
	wp core config --path=/var/www/wordpress --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${MARIADB_HOST} --extra-php < /tmp/wp-config
fi

# Excute arg
exec "$@"