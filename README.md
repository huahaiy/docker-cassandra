docker-cassandra
================

This image runs an Apache Cassandra 2.1 node in a docker container. The data directory is `/cassandra`,  the commitlog directory is `/commitlog`, the cache directory is `/caches`, and they are all exposed as volumes to be linked to host directories.

One can set these environment variables to customize the cluster: 

* `CLUSTER_NAME` Default is "TestCluster" if not set.
* `NODE_NAME` Default is "cass1" if unspecified.
* `BROADCAST_ADDRESS` IP address of the host.
* `LISTEN_ADDRESS` If unspecified, will use docker private IP.
* `SEEDS` A comma-separated list of IP addresses. Default is the docker priviate IP.

The container also continously backups the data to S3 using tablesnap, if these environment variables are set: `AWS_SECRET_KEY`, `AWS_ACCESS_KEY` and `S3_BUCKET`.

