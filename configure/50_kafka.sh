#!/bin/sh

set -e
set -o pipefail

echo "*** configuring Apache Kafka" >&2

KAFKA_CONF="${KAFKA_HOME}/config/server.properties"
KAFKA_DATA_DIR="/home/kafka"

sed -i \
	-e "s|^\\(log\\.dirs=\\).*\$|\\1${KAFKA_DATA_DIR}|g" \
	-e "s|^\\(zookeeper\\.connect=\\).*\$|\\1localhost:${ZOOKEEPER_PORT}|g" \
	-e "s|^\\(#listeners=.*\\)\$|\\1\\nlisteners=PLAINTEXT://:${KAFKA_BOOTSTRAP_PORT}|g" \
	"${KAFKA_CONF}"
