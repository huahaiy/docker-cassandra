#
# The latest Cassandra from Apache 
#
# Version     0.1
#

FROM huahaiy/oracle-java

MAINTAINER Huahai Yang <hyang@juji-inc.com>

RUN \
  echo "===> add apache repository..."  && \ 
  echo "deb http://www.apache.org/dist/cassandra/debian 21x main" | tee \ 
    /etc/apt/sources.list.d/apache.list  && \ 
  echo "deb-src http://www.apache.org/dist/cassandra/debian 21x main" | tee -a \ 
    /etc/apt/sources.list.d/apache.list  && \ 
  apt-key adv --keyserver pgp.mit.edu --recv-keys F758CE318D77295D && \
  apt-key adv --keyserver pgp.mit.edu --recv-keys 2B5C1B00 && \
  apt-key adv --keyserver pgp.mit.edu --recv-keys 0353B12C && \
  apt-get update  && \
  \
  \
  echo "===> install Cassandra and related tools"  && \
  apt-get install -y --force-yes procps  && \
  apt-get install -y --force-yes libjna-java  && \
  apt-get install -y --force-yes cassandra  cassandra-tools && \
  \
  \
  echo "===> clean up..."  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV CASSANDRA_CONFIG /etc/cassandra

ENV CASSANDRA_DATA /cassandra

COPY ./docker-entrypoint.sh /
COPY ./backup-cassandra.sh /usr/bin/

VOLUME ["/cassandra", "/var/lib/cassandra", "/etc/cassandra"]

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22 7000 7001 7199 8888 9042 9160 61620 61621

CMD ["cassandra", "-f"]
