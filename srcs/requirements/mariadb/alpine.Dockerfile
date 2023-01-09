FROM alpine:3.16

ENV MARIADB_ROOT_NAME=root \
	MARIADB_ROOT_PASSWORD=root \
	WORDPRESS_DB_NAME=wordpress \
	WORDPRESS_DB_USER=wordpress \
	WORDPRESS_DB_PASSWORD=wordpress

# Save mariadb history volume
RUN SNIPPET="export PROMPT_COMMAND='history -a' \
	&& export HISTFILE=/commandhistory/.bash_history" \
	&& mkdir /commandhistory \
	&& touch /commandhistory/.bash_history \
	&& echo "$SNIPPET" >> "/root/.bashrc"

# Install mariadb
RUN apk update \
	&& apk add mariadb mariadb-client htop\
	&& rm -rf /var/cache/apk/*

# Copy init script
COPY --chmod=770 ./tools/mariadb_init.sh /tmp/mariadb_init.sh
COPY ./tools/wordpress_init.sql /tmp/wordpress_init.sql

# Copy config file
COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

# Execute maraidb init script
ENTRYPOINT [ "/tmp/mariadb_init.sh" ]

CMD [ "mysqld" ]