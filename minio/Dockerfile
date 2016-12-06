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
ENTRYPOINT ["/data/go/minio", "--config-dir", "/data/go/.minio"]
CMD ["--help"]
