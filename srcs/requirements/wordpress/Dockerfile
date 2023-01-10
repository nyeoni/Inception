FROM alpine:3.16

ENV MARIADB_ROOT_NAME=root \
	MARIADB_ROOT_PASSWORD=root \
	MARIADB_HOST=mariadb \
	WORDPRESS_DB_NAME=wordpress \
	WORDPRESS_DB_USER=wordpress \
	WORDPRESS_DB_PASSWORD=wordpress \
	DOMAIN_NAME=nkim.42.fr \
	WORDPRESS_TITLE=Inception \
	WORDPRESS_ADMIN_USER=wproot \
	WORDPRESS_ADMIN_PASSWORD=wproot \
	WORDPRESS_ADMIN_EMAIL=nkim@student.42seoul.kr \
	WORDPRESS_USER=nkim \
	WORDPRESS_USER_PASSWORD=nkim \
	WORDPRESS_USER_EMAIL=42.4.nkim@gmail.com

# Install php, mariadb-client and curl
RUN apk update \
	&& apk add php8 php8-phar php8-fpm php8-mysqli php8-mbstring php8-json php8-session \
	&& apk add mariadb-client curl \
	&& rm -rf /var/cache/apk/*

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Copy wordpress config file
COPY ./conf/wp-config /tmp/wp-config

# Copy wordpress init script
COPY --chmod=770 ./tools/wordpress_init.sh /tmp/wordpress_init.sh

EXPOSE 9000

ENTRYPOINT [ "/tmp/wordpress_init.sh" ]
