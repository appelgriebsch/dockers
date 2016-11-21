FROM appelgriebsch/golang-runtime:1.7

RUN \
    mkdir -p $GOLANG_APPDIR/shared && \
    chown -R nobody:nobody $GOLANG_APPDIR

# environment variables
ENV MINIO_ACCESS_KEY                '12345'
ENV MINIO_SECRET_KEY                '12345678'
ENV MINIO_ADDRESS                   'localhost:8000'
ENV MINIO_PATH                      '$GOLANG_APPDIR/shared'

VOLUME $GOLANG_APPDIR/shared

USER nobody
ENTRYPOINT $GOLANG_APPDIR/minio --config-dir $GOLANG_APPDIR/.minio server --address $MINIO_ADDRESS $MINIO_PATH
