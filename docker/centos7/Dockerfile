#
# CentOS 7 Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# update system
USER root
RUN \
  yum -y install http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-1.noarch.rpm && \
  sed -i 's/^\(enabled=0.*\)$/# \1/' /etc/yum.repos.d/CentOS-Base.repo && \
  yum -y update && \
  yum clean all
