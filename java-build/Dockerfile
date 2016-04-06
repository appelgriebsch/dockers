
# Java-Build Dockerfile
# VERSION 8.77.03
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="java-build"
LABEL VERSION="8.77.03"

# build source environment variables
# ENV GIT_REPO    'github.com/appelgriebsch/dockers.git'
# ENV GIT_USER    'appelgriebsch'
# ENV GIT_TOKEN   '<github access token>'

# project release tar.gz bundling environment variables
ENV PROJ_NAME     'sample'
ENV PROJ_VER      '0.1.0'

USER root
RUN \
  apk update && \
  apk add openjdk8 python python-dev alpine-sdk util-linux && \
  rm -rf /var/cache/apk/* && \
  cd /tmp && \
  curl -L -o maven.tar.gz "http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz" && \
  tar -xzf maven.tar.gz && \
  mv apache-maven* /usr/local/apache-maven

# adapt path to include maven binary folder
ENV PATH        $PATH:/usr/local/apache-maven/bin

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

# Define mountable directories.
VOLUME /data/build

# Define working directory.
WORKDIR /data/build

# run build
ENTRYPOINT ["/tmp/start_instance.sh"]
