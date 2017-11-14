#!/bin/sh

set -e
set -o pipefail

echo "*** downloading and installing Apache Kafka" >&2

DIST_KAFKA_PATH="/kafka/${KAFKA_VERSION#*-}/kafka_${KAFKA_VERSION}.tgz"
DIST_KAFKA="${APACHE_MIRROR}${DIST_KAFKA_PATH}"
DIST_KAFKA_FILENAME=$(basename "${DIST_KAFKA}")
DIST_KAFKA_ASC="${APACHE_ORIG}${DIST_KAFKA_PATH}.asc"
DIST_KAFKA_ASC_FILENAME=$(basename "${DIST_KAFKA_ASC}")
DEST_DIR=/opt

mkdir -p cache
cd cache
wget -c "${DIST_KAFKA}" "${DIST_KAFKA_ASC}"
gpg --verify "${DIST_KAFKA_ASC_FILENAME}" "${DIST_KAFKA_FILENAME}"
tar -zxf "${DIST_KAFKA_FILENAME}" -C "${DEST_DIR}"
rm "${DIST_KAFKA_ASC_FILENAME}" "${DIST_KAFKA_FILENAME}"
ln -vs $(basename "${DIST_KAFKA_FILENAME}" .tgz) "${KAFKA_HOME}"
cd -
