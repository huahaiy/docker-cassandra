#!/bin/bash
set -e

if [ "$1" = 'supervisord' ]; then
  mkdir -p "$CASSANDRA_DATA"/data
  chown -R cassandra "$CASSANDRA_DATA"
  mkdir -p "$CASSANDRA_COMMITLOG"
  chown -R cassandra "$CASSANDRA_COMMITLOG"
  mkdir -p "$CASSANDRA_CACHES"
  chown -R cassandra "$CASSANDRA_CACHES"

  CLUSTER_NAME=${CLUSTER_NAME:-"TestCluster"}
  NODE_NAME=${NODE_NAME:-"cass1"}
  LISTEN_ADDRESS=${LISTEN_ADDRESS:-`hostname --ip-address`}
  BROADCAST_RPC_ADDRESS=${BROADCAST_ADDRESS}
  SEEDS=${SEEDS:-$LISTEN_ADDRESS}

  sed -i "s,/var/lib/cassandra/data,/cassandra/data," "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s,/var/lib/cassandra/commitlog,/commitlog," "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s,/var/lib/cassandra/saved_caches,/caches," "$CASSANDRA_CONFIG"/cassandra.yaml

  sed -i "s/'Test Cluster'/'$CLUSTER_NAME'/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^listen_address.*/listen_address: $LISTEN_ADDRESS/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^rpc_address.*/rpc_address: 0.0.0.0/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/.*broadcast_address.*/broadcast_address: $BROADCAST_ADDRESS/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/.*broadcast_rpc_address.*/broadcast_rpc_address: $BROADCAST_RPC_ADDRESS/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/- seeds: \".*\"/- seeds: \"$SEEDS\"/" "$CASSANDRA_CONFIG"/cassandra.yaml

  sed -i "s/.*JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=.*\"/JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CASSANDRA_CONFIG/cassandra-env.sh 

  cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true
childlogdir=/var/log/supervisor
loglevel=debug

[program:cassandra]
command=cassandra -f
redirect_stderr=true

EOF

  if [ -n "$S3_BUCKET" ]; then
    cat <<EOF >> /etc/supervisor/conf.d/supervisord.conf
[program:backup]
command=tablesnap -k $AWS_ACCESS_KEY -s $AWS_SECRET_KEY -r -a -B -p $CLUSTER_NAME/ -n $NODE_NAME --keyname-separator / -i $CASSANDRA_DATA/data/((?!system).)*/.* --listen-events IN_MOVED_TO --listen-events IN_CLOSE_WRITE $S3_BUCKET $CASSANDRA_DATA/data 
redirect_stderr=true
EOF
  fi
  # need to set these in the host, as docker disallows them
  #echo "root - memlock unlimited" >> /etc/security/limits.d/cassandra.conf
  #echo "root - nofile 100000" >> /etc/security/limits.d/cassandra.conf
  #echo "root - nproc 32768" >> /etc/security/limits.d/cassandra.conf
  #echo "root - as unlimited" >> /etc/security/limits.d/cassandra.conf
  #echo "vm.max_map_count = 131072" >> /etc/sysctl.conf
fi

exec "$@"
