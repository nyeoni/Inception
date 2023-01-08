-- Create Wordpress Databse
CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;
-- Create Wordpress User
CREATE USER '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';
-- Grant privileges to Wordpress User
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'%';
-- FLUSH PRIVILEGES;
-- Privileges assigned through GRANT option do not need FLUSH PRIVILEGES to take effect - MySQL server will notice these changes and reload the grant tables immediately.