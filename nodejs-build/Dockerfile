
# Nodejs-Build Dockerfile
# VERSION 6.7
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine-sdk:3.4
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-build"
LABEL VERSION="6.7"

# add updated startup-scripts
COPY scripts/*.sh /tmp/scripts/
COPY start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh
