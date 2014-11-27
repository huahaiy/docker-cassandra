#!/bin/bash

while true; do
  sleep 24h 

  nodetool -h localhost clearsnapshot
  nodetool -h localhost snapshot

  # also clear all incremental backups
  find $CASSANDRA_DATA/data -type d -name 'backups' -print0 | xargs -0 rm -rf 
done

