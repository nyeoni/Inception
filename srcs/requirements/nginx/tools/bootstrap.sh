#!/usr/bin/env sh

# Bootstrap nginx
if [ $@ -eq 'log' ]; then
	# run nginx as service
	nginx
	# print nginx log
	tail -f /var/log/nginx/access.log /var/log/nginx/error.log
else
	exec "$@"
fi
