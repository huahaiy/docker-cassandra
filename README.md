docker-cassandra
================

This image runs a cassandra node in a docker container. One can set these environment variables to customize: `CLUSTER_NAME`, `LISTEN_ADDRESS`, `SEEDS`. The data directory is `/cassandra`,  the commitlog directory is `/commitlog`, the cache directory is `/caches`, and they all are exposed as volumes, to be linked to host directories.

The container also continously backups the data to S3 if these environment variables are set: `AWS_SECRET_KEY`, `AWS_ACCESS_KEY` and `S3_BUCKET`.

