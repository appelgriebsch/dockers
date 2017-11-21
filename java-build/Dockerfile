
# Java-Build Dockerfile
# VERSION 1.8
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine-sdk:3.6
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="java-build"
LABEL VERSION="1.8"

USER root
RUN \
  cd /tmp && \
  curl -L -o maven.tar.gz "http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" && \
  tar -xzf maven.tar.gz && \
  cp -R apache-maven*/* /usr/local/ && \
  rm -rf maven.tar.gz apache-maven*

# add updated startup-scripts
COPY scripts/*.sh /tmp/scripts/
COPY start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh
