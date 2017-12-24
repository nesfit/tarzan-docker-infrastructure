#!/bin/sh

set -e
set -o pipefail

echo "*** downloading and installing Apache Cassandra" >&2

DIST_CASSANDRA_PATH="/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz"
DIST_CASSANDRA="${APACHE_MIRROR}${DIST_CASSANDRA_PATH}"
DIST_CASSANDRA_FILENAME=$(basename "${DIST_CASSANDRA}")
DIST_CASSANDRA_ASC="${APACHE_ORIG}${DIST_CASSANDRA_PATH}.asc"
DIST_CASSANDRA_ASC_FILENAME=$(basename "${DIST_CASSANDRA_ASC}")
DEST_DIR=/opt

mkdir -p cache "${DEST_DIR}"
cd cache
wget -c "${DIST_CASSANDRA}" || true # ignore "HTTP/1.1 416 Requested Range Not Satisfiable" error if the file is already fully retrieved
wget "${DIST_CASSANDRA_ASC}"
gpg --verify "${DIST_CASSANDRA_ASC_FILENAME}" "${DIST_CASSANDRA_FILENAME}"
tar -zxf "${DIST_CASSANDRA_FILENAME}" -C "${DEST_DIR}"
rm "${DIST_CASSANDRA_ASC_FILENAME}" "${DIST_CASSANDRA_FILENAME}"
ln -vs $(basename "${DIST_CASSANDRA_FILENAME}" -bin.tar.gz) "${CASSANDRA_HOME}"
cd -
