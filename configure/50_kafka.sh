#!/bin/sh

KAFKA_CONF="${KAFKA_HOME}/config/server.properties"
KAFKA_DATA_DIR="/home/kafka"

sed -i "s|^\(log\.dirs=\).*\$|\1${KAFKA_DATA_DIR}|g" "${KAFKA_CONF}"
