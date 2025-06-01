FROM alpine:3.22

ARG CERT_FINGERPRINT

RUN apk add --no-cache squid openssl bash

WORKDIR /etc/squid/

COPY auth.sh allowed_hostnames allowed_ips banned_ips squid.conf ./
RUN chmod +x /etc/squid/auth.sh

USER root
RUN mkdir /var/spool/squid && chown -R squid:squid /var/spool/squid/ && chown -R squid:squid /etc/squid/
USER squid

EXPOSE 3128/tcp
EXPOSE 3129/tcp

RUN /usr/sbin/squid -z

ENTRYPOINT [ "/usr/sbin/squid" ]

CMD  [ "-N", "-d1", "-f", "/etc/squid/squid.conf" ]