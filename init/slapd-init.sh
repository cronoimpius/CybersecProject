#|/bin/sh

set -eux

readonly DATA_DIR="/init/data"
readonly CONFIG_DIR="/init/config"

readonly LDAP_DOMAIN=example.com
readonly LDAP_ORGANISATION="Example, Inc"
readonly LDAP_BINDDN="cn=admin,dc=example,dc=com"
readonly LDAP_SECRET=admin

reconfigure_slapd(){
echo "Reconfigure slapd..."
    cat <<EOL | debconf-set-selections
slapd slapd/internal/generated_adminpw password ${LDAP_SECRET}
slapd slapd/internal/adminpw password ${LDAP_SECRET}
slapd slapd/password2 password ${LDAP_SECRET}
slapd slapd/password1 password ${LDAP_SECRET}
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/domain string ${LDAP_DOMAIN}
slapd shared/organization string ${LDAP_ORGANISATION}
slapd slapd/purge_database boolean true
slapd slapd/move_old_database boolean true
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
EOL

    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure slapd
}

configure_admin_config_pw(){
  echo "Configure admin config password..."
  adminpw=$(slappasswd -h {SSHA} -s "${LDAP_SECRET}")
  adminpw=$(printf '%s\n' "$adminpw" | sed -e 's/[\/&]/\\&/g')
  sed -i s/ADMINPW/${adminpw}/g ${CONFIG_DIR}/configadminpw.ldif
  ldapmodify -Y EXTERNAL -H ldapi:/// -f ${CONFIG_DIR}/configadminpw.ldif -Q
}

load_initial_data() {
    echo "Load data..."
    local data=$(find ${DATA_DIR} -maxdepth 1 -name \*_\*.ldif -type f | sort)
    for ldif in ${data}; do
        echo "Processing file ${ldif}..."

        base_dn=${LDAP_BASEDN:-}
        if  [ ! -z "${base_dn}" ]; then
            echo "updating base dn dc=example,dc=com -> ${base_dn}"
            sed -i "s/dc=example,dc=com/${base_dn}/g" "${ldif}"
        fi

        domain=${LDAP_DOMAIN:-}
        if  [  "${domain}" != "example.com" ]; then
            echo "updating emails @example.com -> @${domain}"
            sed -i "s/@example.com/@${domain}/g" "${ldif}"
        fi

        ldapadd -x -H ldapi:/// \
          -D ${LDAP_BINDDN} \
          -w ${LDAP_SECRET} \
          -f ${ldif}
    done
}
convert_schema(){
	echo "converting schemas..."
	suffix=".schema"
	local data=$(find ${DATA_DIR} -maxdepth 1 -name \*_*\.schema -type f | sort)
	for schema in ${data}; do
		echo "converting file ${schema} ..."
		schema2ldif ${schema} > ${schema%"$suffix"}.ldif
		ldapadd -Y EXTERNAL -H ldapi:/// -f ${schema%"$suffix"}.ldif -Q
	done
}
# Init
reconfigure_slapd
chown -R openldap:openldap /etc/ldap
slapd -h "ldapi:///" -u openldap -g openldap

configure_admin_config_pw
load_initial_data
convert_schema
PID=$( cat /run/slapd/slapd.pid)
kill -INT $PID && sleep 1
