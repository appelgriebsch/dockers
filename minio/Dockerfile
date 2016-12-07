FROM appelgriebsch/alpine:3.4

# environment variables
ENV GO_APPDIR=/data/go

ENV MINIO_ACCESS_KEY                '12345'
ENV MINIO_SECRET_KEY                '12345678'
ENV MINIO_ADDRESS                   'localhost:8000'
ENV MINIO_PATH                      '$GO_APPDIR/shared'

# prepare image
RUN mkdir -p $GO_APPDIR/shared
COPY ./dist $GO_APPDIR/
RUN chown -R nobody:nobody $GO_APPDIR

VOLUME $GO_APPDIR/shared

USER nobody
CMD ["/data/go/minio", "--config-dir", "/data/go/.minio", "--help"]
