FROM openjdk:8-jdk-alpine

MAINTAINER Marek Rychly <rychly@fit.vutbr.cz>

ENV JAVA_HOME="/usr/lib/jvm/default-jvm"
ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop"
ENV SPARK_HOME="/opt/spark"
ENV CASSANDRA_HOME="/opt/cassandra"
ENV KAFKA_HOME="/opt/kafka"
ENV LIVY_HOME="/opt/livy"
ENV ZEPPELIN_HOME="/opt/zeppelin"
ENV ROTARZAN_HOME="/opt/rysavy-ondrej-tarzan-java"
ENV PATH="${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${CASSANDRA_HOME}/bin:${KAFKA_HOME}/bin:${LIVY_HOME}/bin:${ZEPPELIN_HOME}/bin:/usr/local/bin"
ENV SPARK_MASTER_HOST=localhost
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_URL="spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"
ENV SPARK_MASTER="${SPARK_MASTER_HOST}:${SPARK_HOME}"
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_WORKER_INSTANCES=1
ENV SPARK_WORKER_PORT=8081
ENV SPARK_WORKER_WEBUI_PORT=8081
ENV HDFS_NAMENODE_WEBUI_PORT=50070
ENV CASSANDRA_NATTRANS_PORT=9042
ENV ZOOKEEPER_PORT=2181
ENV KAFKA_BOOTSTRAP_PORT=9092
ENV LIVY_PORT=8998
ENV ZEPPELIN_PORT=8082

# https://hadoop.apache.org/releases.html
ARG HADOOP_VERSION=3.0.0
# https://spark.apache.org/downloads.html
ARG SPARK_VERSION=2.2.1
# https://cassandra.apache.org/download/
ARG CASSANDRA_VERSION=3.11.1
# https://kafka.apache.org/downloads
ARG KAFKA_VERSION=2.11-1.0.0
# https://livy.incubator.apache.org/download/
ARG LIVY_VERSION=0.4.0-incubating
# https://zeppelin.apache.org/download.html
ARG ZEPPELIN_VERSION=0.7.3
# https://github.com/sgerrand/alpine-pkg-glibc/releases
ARG ALPINE_GLIBC_PACKAGE_VERSION=2.26-r0

ARG GUEST_USER=root
ARG GUEST_PASSWORD=tarzan
ARG GUEST_HOME=/home
ARG INSTALL_DIR="/tmp/install"
ARG CONFIGURE_DIR="/tmp/configure"
ARG SPARK_SLAVES_FILE="${SPARK_HOME}/conf/slaves"
ARG SPARK_DEF_CONF="${SPARK_HOME}/conf/spark-defaults.conf"
ARG SPARK_ENV="${SPARK_HOME}/conf/spark-env.sh"

USER ${GUEST_USER}
WORKDIR ${GUEST_HOME}

# prepare

RUN \
apk add --no-cache gnupg rsync openssh git maven bash procps coreutils

# download and install

COPY install "${INSTALL_DIR}"
RUN cd "${INSTALL_DIR}" \
&& . ./env-common.sh && for I in ./??_*.sh; do if [ -x "${I}" ]; then "${I}" || exit $?; fi; done \
&& rm -rf "${INSTALL_DIR}"

# configure

COPY configure "${CONFIGURE_DIR}"
RUN cd "${CONFIGURE_DIR}" \
&& . ./env-common.sh && for I in ./??_*.sh; do if [ -x "${I}" ]; then "${I}" || exit $?; fi; done \
&& rm -rf "${CONFIGURE_DIR}"

# start the main process

EXPOSE \
"${SPARK_MASTER_PORT}" "${SPARK_MASTER_WEBUI_PORT}" "${SPARK_WORKER_PORT}" "${SPARK_WORKER_WEBUI_PORT}" \
"${HDFS_NAMENODE_WEBUI_PORT}" \
"${CASSANDRA_NATTRANS_PORT}" \
"${ZOOKEEPER_PORT}" "${KAFKA_BOOTSTRAP_PORT}" \
"${LIVY_PORT}" \
"${ZEPPELIN_PORT}"

# no entry point -- see Makefile to start the image with applications
#ENTRYPOINT ["/usr/local/bin/tarzan-services-single", "start"]

# however, it is possible to run a shell and start the application manually
CMD ["/bin/sh", "--login"]
