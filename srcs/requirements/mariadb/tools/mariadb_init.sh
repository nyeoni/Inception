#!/usr/bin/env sh
# This script is used to initialize the mariadb database
# It is called by the mariadb container when it starts

# Exit on error
set -ex

# Create the database if it does not exist
if [ ! -d /var/lib/mysql/${WORDPRESS_DB_NAME} ]; then
	# create /var/log/mysql/error.log if it does not exist
	mkdir -p /var/log/mysql
	touch /var/log/mysql/error.log
	# change ownership of /var/lib/mysql to mysql
	chown -R mysql:mysql /var/log/mysql
	chown -R mysql:mysql /var/lib/mysql
	# install initial database
	mysql_install_db --user=mysql --auth-root-authentication-method=normal
	# start mariadb daemon in safe mode
	/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
	# wait for mariadb to start
	if ! mysqladmin -w50 ping > /dev/null 2>&1; then
		echo "Could not connect to mariadb"
		exit 1
	fi
	# set initial root password
	mysqladmin -u ${MARIADB_ROOT_NAME} password ${MARIADB_ROOT_PASSWORD}
	# create user and wordpress database & secure execution sql file
	eval "echo \"$(cat /tmp/wordpress_init.sql)\"" | mariadb -u${MARIADB_ROOT_NAME} -p${MARIADB_ROOT_PASSWORD}
	# stop mariadb daemon
	mysqladmin -u${MARIADB_ROOT_NAME} -p${MARIADB_ROOT_PASSWORD} shutdown

	echo "Mariadb initialization complete"
fi

echo "Starting mariadb daemon"
# start mariadb daemon
exec "$@"