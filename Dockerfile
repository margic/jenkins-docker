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
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -aG docker jenkins    
RUN usermod -aG docker jenkins

USER jenkins

WORKDIR /var/jenkins_home

RUN chown -R jenkins:jenkins /var/jenkins_home

VOLUME /var/run/docker.sock

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]

RUN mkdir /usr/share/jenkins/ref/plugins

