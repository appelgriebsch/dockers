#
# GlusterFS-Connector Dockerfile
# VERSION 3.7.1
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="3.7.1"

# the mount folder for the GlusterFS
ENV GLUSTER_DIR   /data/GlusterFS

# the Gluster Node to connect to
ENV GLUSTER_NODE  "localhost"

# the Gluster Volume to mount
ENV GLUSTER_VOLUME "VOL01"

USER root
RUN \
    cd /etc/yum.repos.d/ && \
    curl -L -O http://download.gluster.org/pub/gluster/glusterfs/LATEST/RHEL/glusterfs-epel.repo && \
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
