#
# ShareLaTeX Dockerfile
# VERSION 0.1.1
#

# Pull CentOS 7 base image
FROM appelgriebsch/nodejs:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# use external redis server found under this address (ip:port)
ENV REDIS_SERVER	127.0.0.1:6379
# password information to connect to external redis server (if required)
# ENV REDIS_PWD			''

# use external mongodb server found under this address (ip:port)
ENV MONGO_SERVER	127.0.0.1:27017
# user information to connect to external mongodb server (if required)
# ENV MONGO_USER		''
# password information to connect to external mongodb server (if required)
# ENV MONGO_PWD		''

# install and configure sharelatex
USER root
ADD ./start_instance.sh /
ADD ./texlive-2014-full.profile /tmp/
RUN \
  yum -y install git aspell aspell-en zlib-devel wget tar perl-Digest-MD5 && \
  yum clean all && \
  mkdir -p /data/sharelatex && \
  git clone -b release https://github.com/sharelatex/sharelatex.git /data/sharelatex/src && \
  cd /data/sharelatex/src && \
  npm install && grunt install && \
  cd /tmp/ && wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
  tar -xzf  install-tl-unx.tar.gz && cd /tmp/install-tl-* && \
  ./install-tl --profile /tmp/texlive-2014-full.profile -q && \
  /usr/local/texlive/2014/bin/x86_64-linux/tlmgr install latexmk && \
  mkdir -p /data/sharelatex/data/user_files && \
  mkdir -p /data/sharelatex/data/compiles && \
  mkdir -p /data/sharelatex/data/cache && \
  mkdir -p /data/sharelatex/tmp/uploads && \
  mkdir -p /data/sharelatex/tmp/dumpFolder && \
  adduser --system --home-dir /data/sharelatex --no-create-home --user-group sharelatex && \
  chown -R sharelatex:sharelatex /data/sharelatex
  
# path env
ENV PATH          /usr/local/texlive/2014/bin/x86_64-linux:$PATH
  
# Define mountable directories.
VOLUME ["/data/sharelatex"]

# Define working directory.
WORKDIR /data/sharelatex

# Expose ports.
EXPOSE 3000

# run service
USER sharelatex
ENTRYPOINT ["/start_instance.sh"]
