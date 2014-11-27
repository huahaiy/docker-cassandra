docker-cassandra
================

This image runs a cassandra node in a docker container. One can set these environment variables to customize: `CLUSTER_NAME`, `LISTEN_ADDRESS`, `SEEDS`. The data directory is `/cassandra`, and is expected to be linked to a host valume; the log and cache directory are in the default locations, under `/var/lib/cassandra`, and this is also exposed as a volume.

The container also continously backups the data to S3 if these environment variables are set: `AWS_SECRET_KEY`, `AWS_ACCESS_KEY` and `S3_BUCKET`.

