FROM alpine:3.16

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

EXPOSE 3306

# Execute maraidb init script
ENTRYPOINT [ "/tmp/mariadb_init.sh" ]

CMD [ "mysqld" ]