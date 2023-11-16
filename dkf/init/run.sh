#!/bin/bash

echo "start slapd op ports 10389 ad 10636"

chown -R openldap:openldap /etc/ldap /var/lib/ldap

exec /usr/sbin/slapd -h "ldapi:/// ldap://0.0.0.0:10389 ldaps://0.0.0.0:10636" \
	-u openldap \
	-g openldap \
	-d ${LDAP_DEBAUG_LEVEL}
