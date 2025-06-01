# Based on https://github.com/dmachard/docker-squid

FROM alpine:3.22 AS build

ENV NAME=squid \
    VERSION=6.12\
    DOWNLOAD_URL=http://www.squid-cache.org/Versions/v6/squid-6.12.tar.gz

ARG CERT_FINGERPRINT

RUN apk update --no-cache && \
    apk add curl build-base openssl-dev perl-dev autoconf automake heimdal-dev libtool libcap-dev linux-headers && \
    curl -sSL $DOWNLOAD_URL -o squid.tar.gz && \
    tar xzf squid.tar.gz && \
    cd $NAME-$VERSION/ && \
    ./configure \
      --prefix=/opt/squid \
      --disable-strict-error-checking \
      --disable-arch-native \
      --enable-delay-pools \
      --enable-linux-netfilter \
      --enable-auth \
      --with-openssl && \
    make && \
    make install

FROM alpine:3.22

COPY --from=build /opt/squid /opt/squid
WORKDIR /opt/squid/

RUN apk add --no-cache libcap libltdl libstdc++ libgcc openssl bash && \
    addgroup -g 1000 _squid && adduser -D -H -G _squid -u 1000 -S _squid && \
    chown _squid:_squid -R /opt/squid

RUN openssl req -x509 -nodes -days 7300 \
            -newkey rsa:2048 -keyout /opt/squid/ssl/privkey.pem -out /opt/squid/ssl/cert.pem \
            -subj $CERT_FINGERPRINT

USER _squid

COPY auth.sh /opt/squid/
RUN chmod +x /opt/squid/auth.sh

EXPOSE 3128/tcp
EXPOSE 3129/tcp

ENTRYPOINT [ "/opt/squid/sbin/squid" ]

CMD  [ "-N", "-d1", "-f", "/opt/squid/etc/squid.conf" ]