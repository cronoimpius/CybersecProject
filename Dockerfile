# Image
FROM debian:buster-backports

ENV DEBIAN_FRONTEND=noninteractive
ENV LDAP_DEBAUG_LEVEL=256

# Install and updates
RUN apt-get update && apt-get install -y --no-install-recommends vim slapd ldap-utils ldapscripts systemctl schema2ldif && \
    rm -rf /var/lib/apt/lists/*

# Copy generated files to the container
COPY ./init /init

# Expose the LDAP port
EXPOSE 10389 10636

# Command to start ldap server
CMD ["/bin/bash", "/init/init.sh"]

#HEALTHCHECK CMD ["ldapsearch", "-H", "ldap://localhost:389", "-D", "${LDAP_BINDDN}", "-w", "${LDAP_SECRET}", "-b", "${LDAP_BINDDN}"]
