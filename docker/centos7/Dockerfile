#
# CentOS 7 Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# update system
USER root
RUN \
  yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm && \
  sed -i 's/^\(enabled=0.*\)$/# \1/' /etc/yum.repos.d/CentOS-Base.repo && \
  yum -y update && \
  yum clean all
