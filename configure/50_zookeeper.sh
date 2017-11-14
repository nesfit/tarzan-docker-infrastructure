#!/bin/sh

set -e
set -o pipefail

echo "*** configuring Apache ZooKeeper" >&2

ZOOKEEPER_CONF="${KAFKA_HOME}/config/zookeeper.properties"
ZOOKEEPER_DATA_DIR="/home/zookeeper"

sed -i \
	-e "s|^\(dataDir=\).*\$|\1${ZOOKEEPER_DATA_DIR}|g" \
	-e "s|^\(clientPort=\).*\$|\1${ZOOKEEPER_PORT}|g" \
	"${ZOOKEEPER_CONF}"
