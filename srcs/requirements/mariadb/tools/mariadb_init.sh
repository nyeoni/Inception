#!/usr/bin/env bash
# This script is used to initialize the mariadb database
# It is called by the mariadb container when it starts

# Exit on error
set -e

# TODO: if 조건문 좋은 방법 고민해보기
# Create the database if it does not exist
if [ ! -d /var/lib/mysql/${WORDPRESS_DB_NAME} ]; then
	# install initial database
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	# start mariadb daemon in safe mode
	/usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
	# wait for mariadb to start
	if ! mysqladmin -w50 ping > /dev/null 2>&1; then
		echo "Could not connect to mariadb"
		exit 1
	fi
	# set initial root password
	mysqladmin -u ${MARIADB_ROOT_NAME} password ${MARIADB_ROOT_PASSWORD}
	# create user and wordpress database
	eval "echo \"$(cat /tmp/wordpress_init.sql)\"" | mariadb
	# stop mariadb daemon
	mysqladmin -u${MARIADB_ROOT_NAME} -p${MARIADB_ROOT_PASSWORD} shutdown

	echo "Mariadb initialization complete"
fi

echo "Starting mariadb daemon"
# start mariadb daemon
exec /usr/bin/mysqld_safe --datadir='/var/lib/mysql'