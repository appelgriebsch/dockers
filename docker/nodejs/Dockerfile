#
# Node.js Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

ENV NVM_DIR /usr/local/nvm

# install nodejs version management system
USER root
RUN \
  yum -y install tar && \
  touch ~/.bashrc && \
  ln -sfv ~/.bashrc ~/.bash_profile && \
  curl https://raw.githubusercontent.com/creationix/nvm/v0.11.0/install.sh | bash && \
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" && \
  nvm install 0.10.29 && \
  nvm use 0.10.29 && \
  npm install -g bower browserify grunt gulp yo

