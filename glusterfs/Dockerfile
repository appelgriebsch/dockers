#
# GlusterFS Dockerfile
# VERSION 3.7.1
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="3.7.1"

# the root folder for the GlusterFS
ENV GLUSTER_DIR   /data/GlusterFS

# the peer for the GlusterFS cluster
#ENV GLUSTER_PEER  ''

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
    cd /etc/yum.repos.d/ && \
    curl -L -O http://download.gluster.org/pub/gluster/glusterfs/LATEST/RHEL/glusterfs-epel.repo && \
    yum -y install glusterfs-server glusterfs-geo-replication glusterfs-api xfsprogs && \
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
EXPOSE  24007 49152

# run service
ENTRYPOINT ["/start_instance.sh"]
