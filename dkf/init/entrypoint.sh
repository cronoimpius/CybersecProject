#!/bin/sh
# Add your LDIF data
#ldapadd -x -D "cn=admin,dc=example,dc=com" -f /container/service/slapd/bootstrap/fake.ldif -w "$LDAP_ADMIN_PASSWORD"

systemctl enable slapd.service
systemctl start slapd.service

#rm /etc/ldap/ldap.conf
cp /init/conf/ldap.conf /etc/ldap/
cp /init/data/*.ldif /etc/ldap/schema/
cp /init/data/*.schema /etc/ldap/schema/

echo "ls /var/lib/ldap"
ls /var/lib/ldap

chown -R openldap:openldap /var/lib/ldap
chown -R openldap:openldap /var/lib/slapd

systemctl enable slapd.service
systemctl restart slapd.service

echo "ldap status"
systemctl status slapd.service

#modify ldap

ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/modpsw.ldif

sleep infinity
