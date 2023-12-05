# Image
FROM debian:buster-backports
USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV LDAP_DEBAUG_LEVEL=256

# Configuration variables

ENV DATA_DIR="/init/data"
ENV CONFIG_DIR="/init/config"

ENV LDAP_DOMAIN=example.com
ENV LDAP_ORGANISATION="Example, Inc"
ENV LDAP_BINDDN="cn=admin,dc=example,dc=com"
ENV LDAP_SECRET=admin

# Install and updates
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev\
    vim \
    slapd \
    ldap-utils \
    ldapscripts \
    systemctl \
    schema2ldif \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get purge python* -y

# update python
RUN wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz 
RUN tar -xvf Python-3.11.1.tgz 
RUN cd Python-3.11.1 && \ 
    ./configure --enable-optimizations && \ 
    make altinstall

# Ollama
RUN pip3.11 install --upgrade pip && pip3.11 install langchain
RUN curl https://ollama.ai/install.sh | sh
# Copy generated files to the container
COPY ./init /init

# Expose the LDAP port
EXPOSE 10389 10636

# Command to start ldap server
CMD ["/bin/bash", "/init/init.sh"]


#HEALTHCHECK CMD ["ldapsearch", "-H", "ldap://localhost:389", "-D", "${LDAP_BINDDN}", "-w", "${LDAP_SECRET}", "-b", "${LDAP_BINDDN}"]
