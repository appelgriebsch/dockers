#
# GlusterFS-Connector Dockerfile
# VERSION 3.7.10
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL VERSION="3.7.10"

# the mount folder for the GlusterFS
ENV GLUSTER_DIR   /data/GlusterFS

# the Gluster Node to connect to
ENV GLUSTER_NODE  "localhost"

# the Gluster Volume to mount
ENV GLUSTER_VOLUME "VOL01"

USER root
RUN \
    yum -y install epel-release && \
    sed -i 's/^\(enabled=0.*\)$/# \1/' /etc/yum.repos.d/CentOS-Base.repo && \
    cd /etc/yum.repos.d/ && \
    curl -L -O "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/glusterfs-epel.repo" && \
    yum -y update && \
    yum -y install glusterfs-fuse && \
    mkdir -p $GLUSTER_DIR

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define working directory.
WORKDIR $GLUSTER_DIR

# export volume
VOLUME  $GLUSTER_DIR

# run service
ENTRYPOINT ["/start_instance.sh"]
