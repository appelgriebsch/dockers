#
# ShareLaTeX Dockerfile
# VERSION 0.1.1
#

# Pull CentOS 7 base image
FROM appelgriebsch/nodejs:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# use external redis server found under this address (ip:port)
ENV REDIS_SERVER      127.0.0.1:6379
# password information to connect to external redis server (if required)
# ENV REDIS_PWD

# use external mongodb server found under this address (ip:port)
ENV MONGO_SERVER      127.0.0.1:27017
# user information to connect to external mongodb server (if required)
# ENV MONGO_USER
# password information to connect to external mongodb server (if required)
# ENV MONGO_PWD

# path env
ENV PATH      /usr/local/texlive/2014/bin/x86_64-linux:$PATH

# install and configure sharelatex
USER root
ADD ./texlive-2014-full.profile /tmp/
## install system requirements
RUN \
  yum -y install git aspell aspell-en zlib-devel wget tar perl-Digest-MD5 && \
  yum clean all
## install TexLive distribution
RUN \
  cd /tmp/ && wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
  tar -xzf  install-tl-unx.tar.gz && cd /tmp/install-tl-* && \
  ./install-tl --profile /tmp/texlive-2014-full.profile && \
  tlmgr install latexmk && \
  rm -rf /tmp/install-tl*
## install sharelatex from github
RUN \
  mkdir -p /data/sharelatex && \
  mkdir -p /data/sharelatex/data/user_files && \
  mkdir -p /data/sharelatex/data/compiles && \
  mkdir -p /data/sharelatex/data/cache && \
  mkdir -p /data/sharelatex/tmp/uploads && \
  mkdir -p /data/sharelatex/tmp/dumpFolder && \
  git clone -b release https://github.com/sharelatex/sharelatex.git /data/sharelatex/www && \
  cd /data/sharelatex/www && \
  npm install && grunt install && \
  adduser --system --home-dir /data/sharelatex --no-create-home --user-group sharelatex && \
  chown -R sharelatex:sharelatex /data/sharelatex


# add start-up script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME ["/data/sharelatex"]

# Define working directory.
WORKDIR /data/sharelatex

# Expose ports.
EXPOSE 3000

# run service
USER sharelatex
ENTRYPOINT ["/start_instance.sh"]
