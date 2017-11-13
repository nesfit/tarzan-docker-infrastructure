#!/bin/sh

DIST_LIVY_PATH="/incubator/livy/${LIVY_VERSION}/livy-${LIVY_VERSION}-bin.zip"
DIST_LIVY="${APACHE_MIRROR}${DIST_LIVY_PATH}"
DIST_LIVY_FILENAME=$(basename "${DIST_LIVY}")
DIST_LIVY_ASC="${APACHE_ORIG}${DIST_LIVY_PATH}.asc"
DIST_LIVY_ASC_FILENAME=$(basename "${DIST_LIVY_ASC}")
DEST_DIR=/opt

cd cache
wget -c "${DIST_LIVY}" "${DIST_LIVY_ASC}"
gpg --verify "${DIST_LIVY_ASC_FILENAME}" "${DIST_LIVY_FILENAME}"
unzip -q "${DIST_LIVY_FILENAME}" -d "${DEST_DIR}"
rm "${DIST_LIVY_ASC_FILENAME}" "${DIST_LIVY_FILENAME}"
ln -vs $(basename "${DIST_LIVY_FILENAME}" .zip) "${DEST_DIR}/livy"
cd -
