#!/bin/bash

parse_url() {
  
  # extract the protocol
  proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"

  # remove the protocol -- updated
  url=$(echo $1 | sed -e s,$proto,,g)

  # extract the user (if any)
  user="$(echo $url | grep @ | cut -d@ -f1)"

  # extract the host -- updated
  host=$(echo $url | sed -e s,$user@,,g | cut -d/ -f1)

  # by request - try to extract the port
  port="$(echo $host | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
  hostname="$(echo $host | grep : | cut -d: -f1)"

  # extract the path (if any)
  path="$(echo $url | grep / | cut -d/ -f2-)"

  if [ -n "$hostname" ]; then
     echo "  proxy_host = $hostname" >> /tmp/.s3cmd
  fi

  if [ -n "$port" ]; then
    echo "  proxy_port = $port" >> /tmp/.s3cmd
  fi
}

cat <<EOF > /tmp/.s3cmd
  # Setup endpoint
  host_base = $S3_ENDPOINT
  host_bucket = $S3_ENDPOINT
  bucket_location = $S3_LOCALITY
  use_https = $S3_EP_HTTPS

  # Setup access keys
  access_key =  $S3_ACCESS_KEY
  secret_key = $S3_SECRET_KEY

  # Enable S3 v4 signature APIs
  signature_v2 = False
EOF

if [ "$#" == "0" ]; then
  "s3cmd" "--help"
else
  echo "Creating S3 configuration..."
  
  if [ "$S3_EP_HTTPS" == "true" ]; then
    parse_url $https_proxy
  else
    parse_url $http_proxy
  fi

  chmod 600 /tmp/.s3cmd

  echo "Checking for S3 bucket... $S3_BUCKET"
  RES=$(s3cmd --config=/tmp/.s3cmd ls s3://$S3_BUCKET 2>&1)

  if [[ "$RES" == *"ERROR"* ]]; then
    echo "Creating S3 bucket... $S3_BUCKET"
    s3cmd --config=/tmp/.s3cmd mb s3://$S3_BUCKET 2>&1
  fi

  if [ -n "$S3_CACHE_DIR" ]; then
    echo Creating local cache path $S3_CACHE_DIR.
    mkdir -p $S3_CACHE_DIR
    chown -R nobody:nobody $S3_CACHE_DIR
  fi

  SYNC_OPTIONS=""
  if [ "$S3_FORCE_REMOVE" == "true" ]; then
    SYNC_OPTIONS="--force"
  fi

  echo Initial synchronization from $S3_BUCKET to $S3_CACHE_DIR...
  s3cmd --config=/tmp/.s3cmd sync s3://$S3_BUCKET $S3_CACHE_DIR --recursive

  while [ true ]; do
    echo Synching folders from $S3_CACHE_DIR to $S3_BUCKET...
    s3cmd --config=/tmp/.s3cmd sync $S3_CACHE_DIR s3://$S3_BUCKET --recursive --delete-removed $SYNC_OPTIONS
    sleep $S3_SYNC_INTERVAL
  done
fi
