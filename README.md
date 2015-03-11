docker-cassandra
================

This image runs an Apache Cassandra 2.1 node in a docker container. One can set these environment variables to customize: `CLUSTER_NAME`, `NODE_NAME`, `LISTEN_ADDRESS`, `SEEDS`. The data directory is `/cassandra`,  the commitlog directory is `/commitlog`, the cache directory is `/caches`, and they are all exposed as volumes, to be linked to host directories.

The container also continously backups the data to S3 if these environment variables are set: `AWS_SECRET_KEY`, `AWS_ACCESS_KEY` and `S3_BUCKET`.

