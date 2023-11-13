# Image
FROM debian:buster-backports

ENV DEBIAN_FRONTEND=noninteractive
# Install and updates
RUN echo "slapd/root_password password ciao" | debconf-set-selections && \
    echo "slapd/root_password_again password ciao" | debconf-set-selections && \
    apt-get update && apt-get install -y --no-install-recommends vim slapd ldap-utils ldapscripts systemctl && \
    rm -rf /var/lib/apt/lists/*

# Set the LDAP administrator password during package configuration
# Copy generated files to the container
COPY ./init /init
#COPY ./fake_data/*.schema /container/service/slapd/bootstrap/
#COPY ./fake_data/*.ldif /container/service/slapd/bootstrap/
#COPY ./entrypoint.sh /

WORKDIR /init

RUN #rm -r /etc/ldap/slapd.d/ && \
    chmod +x /init/entrypoint.sh
# Expose the LDAP port
EXPOSE 389

ENV LDAP_URIS="ldap:///"

# Command to start ldap server
#CMD ["slapd","-d","1"]
ENTRYPOINT ["./entrypoint.sh"]
