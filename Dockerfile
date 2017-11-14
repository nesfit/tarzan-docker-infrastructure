FROM centos:latest

MAINTAINER Marek Rychly <rychly@fit.vutbr.cz>

ENV SPARK_MASTER_HOST=localhost
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER="spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT}"
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
ENV JAVA_HOME="/etc/alternatives/java_sdk"
ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop"
ENV SPARK_HOME="/opt/spark"
ENV CASSANDRA_HOME="/opt/cassandra"
ENV KAFKA_HOME="/opt/kafka"
ENV LIVY_HOME="/opt/livy"
ENV ZEPPELIN_HOME="/opt/zeppelin"
ENV PATH="${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${CASSANDRA_HOME}/bin:${KAFKA_HOME}/bin:${LIVY_HOME}/bin:${ZEPPELIN_HOME}/bin:/usr/local/bin"

ARG INSTALL_DIR="/tmp/install"
ARG CONFIGURE_DIR="/tmp/configure"
ARG HADOOP_VERSION=2.8.2
ARG SPARK_VERSION=2.2.0
ARG CASSANDRA_VERSION=3.11.1
ARG KAFKA_VERSION=2.11-1.0.0
ARG LIVY_VERSION=0.4.0-incubating
ARG ZEPPELIN_VERSION=0.7.3
ARG SPARK_SLAVES_FILE="${SPARK_HOME}/conf/slaves"
ARG SPARK_DEF_CONF="${SPARK_HOME}/conf/spark-defaults.conf"
ARG SPARK_ENV="${SPARK_HOME}/conf/spark-env.sh"

USER root
WORKDIR /home

# prepare

RUN \
yum install -y epel-release wget gpg tar unzip which java-devel rsync openssh-server openssh-clients && \
yum clean all && \
rm -rf /var/cache/yum

# download and install

COPY install "${INSTALL_DIR}"
RUN cd "${INSTALL_DIR}" && for I in ./*.sh; do "${I}" || exit $?; done

# configure

COPY configure "${CONFIGURE_DIR}"
RUN cd "${CONFIGURE_DIR}" && for I in ./*.sh; do "${I}" || exit $?; done

# clean and finish

RUN rm -rf "${INSTALL_DIR}" "${CONFIGURE_DIR}"

# start the main process

EXPOSE \
"${SPARK_MASTER_PORT}" "${SPARK_MASTER_WEBUI_PORT}" "${SPARK_WORKER_PORT}" "${SPARK_WORKER_WEBUI_PORT}" \
"${HDFS_NAMENODE_WEBUI_PORT}" \
"${CASSANDRA_NATTRANS_PORT}" \
"${ZOOKEEPER_PORT}" "${KAFKA_BOOTSTRAP_PORT}" \
"${LIVY_PORT}" \
"${ZEPPELIN_PORT}"

# no entry point -- see Makefile to start
#ENTRYPOINT ["/usr/local/bin/tarzan-start-single"]
