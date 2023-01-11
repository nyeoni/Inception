FROM alpine:3.16

RUN apk update \
	&& apk add nginx openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nkim42fr.key \
	-out /etc/nginx/ssl/nkim42fr.crt \
	-subj "/C=KR/ST=Seoul/L=Seoul/O=42/OU=42seoul/CN=nkim.42.fr" \
	&& rm -rf /var/cache/apk/*

# Copy nginx config file
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

# Copy bootstrap script
COPY --chmod=700 ./tools/bootstrap.sh /tmp/bootstrap.sh

ENTRYPOINT [ "/tmp/bootstrap.sh" ]
