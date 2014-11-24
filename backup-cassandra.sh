#!/bin/bash

if [[ -z "$CASSANDRA_HOSTS" ]]; then
  export CASSANDRA_HOSTS=$(env | grep CASSANDRA_PORT_22_TCP_ADDR= | sed -e 's|CASSANDRA_PORT_22_TCP_ADDR=||' | paste -sd ,)
fi

# TODO: ssh into a docker seems to be too complicated. It's better to use another container to do the snapshot using native nodetool, then use awscli to copy the files over to S3, and put the script in cron.
#cassandra-snapshotter --aws-access-key-id="$AWS_ACCESS_KEY" --aws-secret-access-key="$AWS_SECRET_KEY" --s3-bucket-name="$S3_BUCKET" --s3-bucket-region="$S3_REGION" --s3-base-path="$S3_PATH" backup --hosts="$CASSANDRA_HOSTS" --user=cassandra
