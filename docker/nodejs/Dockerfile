#
# Node.js Dockerfile
# VERSION 0.10.32

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# default path to the nodejs project files
ENV NODEJS_DIR		/data/nodejs

# install nodejs
USER root
# ADD ./start_instance.sh /
RUN \
  curl -sL https://rpm.nodesource.com/setup | bash - && \
  yum install -y nodejs gcc-c++ make && \
  yum clean all && \
  npm install -g grunt-cli gulp bower browserify && \
  npm cache clean && \
  mkdir -p /data/nodejs && \
  adduser --system --home-dir /data/nodejs --no-create-home --user-group nodejs && \
  chown -R nodejs:nodejs /data/nodejs

# Define mountable directories.
VOLUME ["/data/nodejs"]

# Define working directory.
WORKDIR /data/nodejs

# Expose ports.
EXPOSE 3000

# run service
USER nodejs
ENTRYPOINT ["npm"]
