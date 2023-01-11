#!/usr/bin/env sh

# Bootstrap nginx
nginx

# Print nginx logs
# if [ $? -eq 0 ]; then
# 	tail -f /var/log/nginx/access.log /var/log/nginx/error.log
# fi

exec "$@"