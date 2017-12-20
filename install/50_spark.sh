#!/bin/sh

set -e
set -o pipefail

echo "*** downloading and installing Apache Spark" >&2

DIST_SPARK_PATH="/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz"
DIST_SPARK="${APACHE_MIRROR}${DIST_SPARK_PATH}"
DIST_SPARK_FILENAME=$(basename "${DIST_SPARK}")
DIST_SPARK_ASC="${APACHE_ORIG}${DIST_SPARK_PATH}.asc"
DIST_SPARK_ASC_FILENAME=$(basename "${DIST_SPARK_ASC}")
DEST_DIR=/opt

mkdir -p cache "${DEST_DIR}"
cd cache
wget -c "${DIST_SPARK}" || true # ignore "HTTP/1.1 416 Requested Range Not Satisfiable" error if the file is already fully retrieved
wget "${DIST_SPARK_ASC}"
gpg --verify "${DIST_SPARK_ASC_FILENAME}" "${DIST_SPARK_FILENAME}"
tar -zxf "${DIST_SPARK_FILENAME}" -C "${DEST_DIR}"
rm "${DIST_SPARK_ASC_FILENAME}" "${DIST_SPARK_FILENAME}"
ln -vs $(basename "${DIST_SPARK_FILENAME}" .tgz) "${SPARK_HOME}"
cd -
