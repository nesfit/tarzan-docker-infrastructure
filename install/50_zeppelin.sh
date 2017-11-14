#!/bin/sh

set -e
set -o pipefail

echo "*** downloading and installing Apache Zeppelin" >&2

DIST_ZEPPELIN_PATH="/zeppelin/zeppelin-${ZEPPELIN_VERSION}/zeppelin-${ZEPPELIN_VERSION}-bin-netinst.tgz"
DIST_ZEPPELIN="${APACHE_MIRROR}${DIST_ZEPPELIN_PATH}"
DIST_ZEPPELIN_FILENAME=$(basename "${DIST_ZEPPELIN}")
DIST_ZEPPELIN_ASC="${APACHE_ORIG}${DIST_ZEPPELIN_PATH}.asc"
DIST_ZEPPELIN_ASC_FILENAME=$(basename "${DIST_ZEPPELIN_ASC}")
DEST_DIR=/opt

mkdir -p cache
cd cache
wget -c "${DIST_ZEPPELIN}" "${DIST_ZEPPELIN_ASC}"
gpg --verify "${DIST_ZEPPELIN_ASC_FILENAME}" "${DIST_ZEPPELIN_FILENAME}"
tar -zxf "${DIST_ZEPPELIN_FILENAME}" -C "${DEST_DIR}"
rm "${DIST_ZEPPELIN_ASC_FILENAME}" "${DIST_ZEPPELIN_FILENAME}"
ln -vs $(basename "${DIST_ZEPPELIN_FILENAME}" .tgz) "${ZEPPELIN_HOME}"
cd -
