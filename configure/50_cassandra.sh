#!/bin/sh

CASSANDRA_CONF="${CASSANDRA_HOME}/conf/cassandra.yaml"
CASSANDRA_DATA_DIR="/home/cassandra"

mkdir -p "${CASSANDRA_DATA_DIR}"

cat <<END >> "${CASSANDRA_CONF}"

cdc_raw_directory: ${CASSANDRA_DATA_DIR}/cdc_raw

commitlog_directory: ${CASSANDRA_DATA_DIR}/commitlog

data_file_directories:
- ${CASSANDRA_DATA_DIR}/data

hints_directory: ${CASSANDRA_DATA_DIR}/hints

saved_caches_directory: ${CASSANDRA_DATA_DIR}/saved_caches

END
