FROM jenkins:latest
MAINTAINER pmcrofts@margic.com

USER root

# Install uuid
RUN apt-get update \
        && apt-get install -y uuid \
        libmysqlclient-dev \
        libxml2-dev \
        libxslt1-dev \
        supervisor \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        sudo \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -a -G docker jenkins    

WORKDIR /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home

# Setup jenkins user to allow access tp /var/run/docker.sock
# This allow changing owner of the docker.sock later
COPY ./sudoers /etc/sudoers

USER jenkins

RUN mkdir /usr/share/jenkins/ref/plugins
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
