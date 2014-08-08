#
# CentOS 6 Dockerfile
#

# Pull CentOS 6 base image
FROM centos:centos6
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# update system
USER root
RUN \
  yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
  sed -i 's/^\(enabled=0.*\)$/# \1/' /etc/yum.repos.d/CentOS-Base.repo && \
  yum -y update && \
  yum clean all
