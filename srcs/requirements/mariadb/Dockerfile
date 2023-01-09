FROM debian:buster

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
RUN apt-get update && apt-get install -y \
	mariadb-server \
	mariadb-client \
	htop \
	&& rm -rf /var/lib/apt/lists/*

# Copy init script
COPY --chmod=770 ./tools/mariadb_init.sh /tmp/mariadb_init.sh
COPY ./tools/wordpress_init.sql /tmp/wordpress_init.sql

# Copy config file
COPY ./conf/mariadb-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Execute maraidb init script
ENTRYPOINT [ "/tmp/mariadb_init.sh" ]

CMD [ "mysqld" ]
