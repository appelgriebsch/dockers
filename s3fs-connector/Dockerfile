# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:3.5
MAINTAINER Andreas Gerlach <andreas.gerlach@dieboldnixdorf.com>
LABEL AUTHOR="Andreas Gerlach <andreas.gerlach@dieboldnixdorf.com>"
LABEL NAME="s3fs"
LABEL VERSION="0.1.0"

# environment variables
ENV S3_ENDPOINT                  'localhost:2379'
ENV S3_BUCKET                    'test'
ENV S3_LOCALITY                  'us-east-1'

ENV S3_EP_HTTPS                  'false'
ENV S3_ACCESS_KEY                '12345'
ENV S3_SECRET_KEY                '12345678'

ENV S3_CACHE_DIR                 '/data/cache/'
ENV S3_SYNC_INTERVAL             '10s'

# prepare image
USER root
COPY ./s3fs.sh /tmp/
RUN pip install s3cmd && \
    mkdir -p $S3_CACHE_DIR && \
    chown -R nobody:nobody $S3_CACHE_DIR && \
    chmod 755 /tmp/s3fs.sh

# Define Volume
VOLUME $S3_CACHE_DIR

# Define working directory.
WORKDIR $S3_CACHE_DIR

USER nobody
ENTRYPOINT ["/tmp/start_instance.sh", "/tmp/s3fs.sh"]
