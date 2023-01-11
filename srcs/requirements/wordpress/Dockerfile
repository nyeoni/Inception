FROM alpine:3.16

# Install php, mariadb-client and curl
RUN apk update \
	&& apk add php8 php8-phar php8-fpm php8-mysqli php8-mbstring php8-json php8-session \
	&& apk add mariadb-client curl \
	&& rm -rf /var/cache/apk/*

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Copy php-fpm config file
COPY ./conf/www.conf /etc/php8/php-fpm.d

# Copy wordpress config file
COPY ./conf/wp-config /tmp/wp-config

# Copy wordpress init script
COPY --chmod=770 ./tools/wordpress_init.sh /tmp/wordpress_init.sh

EXPOSE 9000

ENTRYPOINT [ "/tmp/wordpress_init.sh" ]

CMD [ "php-fpm8", "-F" ]
