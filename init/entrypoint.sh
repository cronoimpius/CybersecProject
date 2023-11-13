#!/bin/sh
# Add your LDIF data
#ldapadd -x -D "cn=admin,dc=example,dc=com" -f /container/service/slapd/bootstrap/fake.ldif -w "$LDAP_ADMIN_PASSWORD"

systemctl enable slapd.service
systemctl start slapd.service

cp /init/conf/slapd.conf /etc/ldap/slapd.conf
cp /init/fake_data/*.ldif /etc/ldap/schema/
cp /init/fake_data/*.schema /etc/ldap/schema/

echo "ls /var/lib/ldap"
ls /var/lib/ldap

chown -R openldap:openldap /var/lib/ldap
chown -R openldap:openldap /var/lib/slapd

systemctl enable slapd.service
systemctl restart slapd.service

echo "ldap status"
systemctl status slapd.service

sleep infinity
