#!/bin/bash
set -e

if [ "$1" = 'cassandra' ]; then
  mkdir -p "$CASSANDRA_DATA"/data
  chown -R cassandra "$CASSANDRA_DATA"

  CLUSTER_NAME=${CLUSTER_NAME:-"TestCluster"}
  IP=${LISTEN_ADDRESS:-`hostname --ip-address`}
  SEEDS=${SEEDS:-$IP}

  sed -i "s,/var/lib/cassandra/data,/cassandra/data," "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/'Test Cluster'/'$CLUSTER_NAME'/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^listen_address.*/listen_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^rpc_address.*/rpc_address: 0.0.0.0/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/# broadcast_address.*/broadcast_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/# broadcast_rpc_address.*/broadcast_rpc_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  #sed -i "s/incremental_backups: false/incremental_backups: true/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" "$CASSANDRA_CONFIG"/cassandra.yaml

  sed -i "s/# JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CASSANDRA_CONFIG/cassandra-env.sh 

  # need to set these in the host, as docker disallows them
  #echo "root - memlock unlimited" >> /etc/security/limits.d/cassandra.conf
  #echo "root - nofile 100000" >> /etc/security/limits.d/cassandra.conf
  #echo "root - nproc 32768" >> /etc/security/limits.d/cassandra.conf
  #echo "root - as unlimited" >> /etc/security/limits.d/cassandra.conf
  #echo "vm.max_map_count = 131072" >> /etc/sysctl.conf

  if [ -n "$S3_BUCKET" ]; then 
    sed -i "s/RUN=no/RUN=yes/" /etc/default/tablesnap
    sed -i "s|\(DAEMON_OPTS=\"\).*\(\"\)|\1-k $AWS_ACCESS_KEY -s $AWS_SECRET_KEY -r -a -B -p $CLUSTER_NAME/ -n $NODE_NAME --keyname-separator / --listen-events IN_MOVED_TO --listen-events IN_CLOSE_WRITE $S3_BUCKET $CASSANDRA_DATA/data\2|" /etc/default/tablesnap
    /etc/init.d/tablesnap start
  fi 
fi

exec "$@"
