#!/bin/bash
set -e
if [ "$1" = 'cassandra' ]; then
  chown -R cassandra "$CASSANDRA_DATA"
  IP=${LISTEN_ADDRESS:-`hostname --ip-address`}
  SEEDS=${SEEDS:-$IP}
  sed -i "s,/var/lib/cassandra/data,/cassandra/data," "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^listen_address.*/listen_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/^rpc_address.*/rpc_address: 0.0.0.0/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/# broadcast_address.*/broadcast_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/# broadcast_rpc_address.*/broadcast_rpc_address: $IP/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" "$CASSANDRA_CONFIG"/cassandra.yaml
  sed -i -e "s/# JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/ JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CASSANDRA_CONFIG/cassandra-env.sh
  exec "$@"
fi
exec "$@"
