#!/bin/sh

set -e
set -o pipefail

echo "*** configuring Apache Cassandra" >&2

CASSANDRA_CONF="${CASSANDRA_HOME}/conf/cassandra.yaml"
CASSANDRA_LOGS="${CASSANDRA_HOME}/logs"
CASSANDRA_DATA_DIR="/home/cassandra"

mkdir -p "${CASSANDRA_DATA_DIR}" "${CASSANDRA_LOGS}"

sed -i \
	-e "s|^\\(native_transport_port: \\).*\\$|\\1${CASSANDRA_NATTRANS_PORT}|g" \
	"${CASSANDRA_CONF}"

cat <<END >> "${CASSANDRA_CONF}"

cdc_raw_directory: ${CASSANDRA_DATA_DIR}/cdc_raw

commitlog_directory: ${CASSANDRA_DATA_DIR}/commitlog

data_file_directories:
- ${CASSANDRA_DATA_DIR}/data

hints_directory: ${CASSANDRA_DATA_DIR}/hints

saved_caches_directory: ${CASSANDRA_DATA_DIR}/saved_caches

END
