
# Nodejs-Build Dockerfile
# VERSION 6.9
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine-sdk:3.5
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-build"
LABEL VERSION="6.9"

# add updated startup-scripts
COPY scripts/*.sh /tmp/scripts/
COPY start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh
