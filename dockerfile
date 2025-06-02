FROM alpine:3.22

RUN apk add --no-cache squid openssl bash apache2-utils expect

WORKDIR /etc/squid/

COPY auth.sh allowed_hostnames allowed_ips banned_ips squid.conf certs/privkey.pem certs/fullchain.pem entrypoint.sh digest_user.exp ./
RUN chmod +x /etc/squid/auth.sh /etc/squid/entrypoint.sh /etc/squid/digest_user.exp

USER root
RUN mkdir /var/spool/squid && chown -R squid:squid /var/spool/squid/ && chown -R squid:squid /etc/squid/
USER squid

EXPOSE 3128/tcp
EXPOSE 3129/tcp

ENTRYPOINT [ "/etc/squid/entrypoint.sh" ]

CMD  [ "-N", "-d1", "-f", "/etc/squid/squid.conf" ]