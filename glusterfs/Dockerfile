#
# GlusterFS Dockerfile
# VERSION 3.7.10
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL VERSION="3.7.10"

# the root folder for the GlusterFS
ENV GLUSTER_DIR   /data/GlusterFS

# the peers for the GlusterFS cluster
#ENV GLUSTER_PEERS  ''

# the size of the image file
ENV IMAGE_SIZE    100MB

# the name of the brick
ENV BRICK_NAME    BR01

# the name of the volume
ENV VOLUME_NAME   VOL01

# the number of replicas
# ENV REPLICA_CNT   1

# the number of stripes
# ENV STRIPE_CNT    1

USER root
RUN \
    yum -y install epel-release && \
    sed -i 's/^\(enabled=0.*\)$/# \1/' /etc/yum.repos.d/CentOS-Base.repo && \
    cd /etc/yum.repos.d/ && \
    curl -L -O "http://download.gluster.org/pub/gluster/glusterfs/LATEST/EPEL.repo/glusterfs-epel.repo" && \
    yum -y update && \
    yum -y install glusterfs-server glusterfs-geo-replication glusterfs-api glusterfs-cli glusterfs-rdma xfsprogs && \
    mkdir -p $GLUSTER_DIR

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define working directory.
WORKDIR $GLUSTER_DIR

# export volume
VOLUME  $GLUSTER_DIR

# expose default GlusterFS ports
EXPOSE 111 24007 38465 38466 38467 49152

# run service
ENTRYPOINT ["/start_instance.sh"]
