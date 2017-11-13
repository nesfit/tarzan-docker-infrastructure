#!/bin/sh

ZOOKEEPER_CONF="${KAFKA_HOME}/config/zookeeper.properties"
ZOOKEEPER_DATA_DIR="/home/zookeeper"

sed -i "s|^\(dataDir=\).*\$|\1${ZOOKEEPER_DATA_DIR}|g" "${ZOOKEEPER_CONF}"
