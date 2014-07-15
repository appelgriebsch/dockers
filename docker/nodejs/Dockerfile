#
# Node.js Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

ENV NVM_DIR /usr/local/nvm

# update system
RUN \
  rpm -Uhv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
  yum -y update && \
  yum -y install tar && \
  touch ~/.bash_profile && \
  curl https://raw.githubusercontent.com/creationix/nvm/v0.10.0/install.sh | bash && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  nvm install 0.10.29 && \
  nvm use 0.10.29 && \
  npm install -g bower browserify grunt gulp yo

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data
