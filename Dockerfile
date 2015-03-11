#
# Run the latest Cassandra from Apache, also setup snapshot and 
# incremental backup to S3
#
# Version     0.3
#

FROM huahaiy/oracle-java

MAINTAINER Huahai Yang <hyang@juji-inc.com>

RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

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
  echo "===> install Cassandra"  && \
  apt-get install -y --force-yes procps  && \
  apt-get install -y --force-yes cassandra  cassandra-tools 

COPY ./tablesnap_0.6.2-1_amd64.deb /

RUN \ 
  echo "===> install supervisor and tablesnap"  && \
  apt-get install -y supervisor python-pyinotify python-boto python-dateutil && \
  dpkg -i tablesnap_0.6.2-1_amd64.deb && \
  mkdir -p /var/log/supervisor && \
  \
  \
  echo "===> clean up..."  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV CASSANDRA_CONFIG /etc/cassandra

ENV CASSANDRA_DATA /cassandra

ENV CASSANDRA_COMMITLOG /commitlog

ENV CASSANDRA_CACHES /caches

COPY ./docker-entrypoint.sh /

VOLUME ["/cassandra", "/commitlog", "/caches", "/dev/log", "/etc/cassandra"]

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22 7000 7001 7199 8888 9042 9160 61620 61621

CMD ["supervisord"]
