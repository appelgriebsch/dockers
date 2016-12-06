FROM appelgriebsch/go-runtime:1.7

RUN \
    mkdir -p $GO_APPDIR/shared && \
    chown -R nobody:nobody $GO_APPDIR

# environment variables
ENV MINIO_ACCESS_KEY                '12345'
ENV MINIO_SECRET_KEY                '12345678'
ENV MINIO_ADDRESS                   'localhost:8000'
ENV MINIO_PATH                      '$GO_APPDIR/shared'

VOLUME $GO_APPDIR/shared

USER nobody
ENTRYPOINT $GO_APPDIR/minio --config-dir $GO_APPDIR/.minio server --address $MINIO_ADDRESS $MINIO_PATH
