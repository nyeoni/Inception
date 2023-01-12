#!/usr/bin/env sh
# This script is used to initialize the wordpress
# It is called by the wordpress container when it starts

# Exit on error
set -x

# Create wordpress directory
if [ ! -d /var/www/wordpress ]; then
	# create wordpress directory if not exists
	mkdir -p /var/www/wordpress
fi

# Check mariadb server
mariadb-admin ping  -u${MARIADB_ROOT_NAME} -p${MARIADB_ROOT_PASSWORD} --host=${MARIADB_HOST} --wait=1 --connect-timeout=30

# Install wordpress
if ! wp core is-installed --allow-root --path=/var/www/wordpress; then
	# download latest wordpress to wordpress path
	wp core download --path=/var/www/wordpress
	# create www-data system user if not exists
	adduser -D -S -H -G www-data www-data
	# change ownership of wordpress directory to www-data
	chown -R www-data:www-data /var/www/wordpress

	# create wordpress config file
	if [ ! -f /var/www/wordpress/wp-config.php ]; then
		# create wordpress config file
		wp core config --allow-root --path=/var/www/wordpress --dbname=${WORDPRESS_DB_NAME} --dbuser=${WORDPRESS_DB_USER} --dbpass=${WORDPRESS_DB_PASSWORD} --dbhost=${MARIADB_HOST} --extra-php < /tmp/wp-config
		echo 'Wordpress Config file created'
	else
		echo 'Wordpress Config file already exists'
	fi

	# create wordpress tables in the database and create admin user
	wp core install --allow-root --path=/var/www/wordpress \
	--url=${DOMAIN_NAME} \
	--title=${WORDPRESS_TITLE} \
	--admin_user=${WORDPRESS_ADMIN_USER} \
	--admin_password=${WORDPRESS_ADMIN_PASSWORD} \
	--admin_email=${WORDPRESS_ADMIN_EMAIL}
	# create user
	wp user create --allow-root --path=/var/www/wordpress ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} --role=author --user_pass=${WORDPRESS_USER_PASSWORD}
fi

# Excute arg
if [ "$@" -eq 'log' ]; then
	# Start php-fpm
	php-fpm8
	# Print php-fpm logs
	tail -f /var/log/php8/*access.log
else
	exec "$@"
fi