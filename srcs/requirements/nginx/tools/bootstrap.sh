#!/usr/bin/env sh

# Check arg
if [ "$#" -eq 0 ]; then
	echo "Nginx is starting..."
	nginx -g 'daemon off;'
	exit 0
fi

# Bootstrap nginx
if [ "$@" = "log" ]; then
	# run nginx as service
	echo "Nginx is starting..."
	nginx
	# print nginx log
	tail -f /var/log/nginx/access.log /var/log/nginx/error.log
else
	exec "$@"
fi
