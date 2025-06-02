#!/bin/sh
# Auth for digest auth scheme
./digest_user.exp $USERNAME $PASS $REALM
/usr/sbin/squid -z
/usr/sbin/squid $@