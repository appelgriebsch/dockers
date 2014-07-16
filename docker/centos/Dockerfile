#
# Redis Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# update system
USER root
RUN \
  rpm -Uhv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
  yum -y update

# install supervisor
USER root
RUN \
  yum -y install supervisor && \
  sed -i 's/^\(nodaemon.*\)$/# \1\nnodaemon=true/' /etc/supervisord.conf
