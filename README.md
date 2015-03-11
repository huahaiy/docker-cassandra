docker-cassandra
================

This image runs an Apache Cassandra 2.1 node in a docker container. The data directory is `/cassandra`,  the commitlog directory is `/commitlog`, the cache directory is `/caches`, and they are all exposed as volumes to be linked to host directories.

One can set these environment variables to customize the cluster: 

* `CLUSTER_NAME` Default is "TestCluster" if not set.
* `NODE_NAME` Default is "cass1" if unspecified, used as part of backup path name.
* `SEEDS` A comma-separated list of IP addresses. 

If the following environment variables are set: `AWS_SECRET_KEY`, `AWS_ACCESS_KEY` and `S3_BUCKET`, the container also continuously backups the data to S3 using tablesnap. tablesnap and cassandra are both managed by supervisord.

This image supports multi-node cluster, where one needs to run each container with `--net=host` option on a separate host. 
