#!/bin/sh

set -e
set -o pipefail

echo "*** downloading and installing Apache Hadoop" >&2

DIST_HADOOP_PATH="/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
DIST_HADOOP="${APACHE_MIRROR}${DIST_HADOOP_PATH}"
DIST_HADOOP_FILENAME=$(basename "${DIST_HADOOP}")
DIST_HADOOP_ASC="${APACHE_ORIG}${DIST_HADOOP_PATH}.asc"
DIST_HADOOP_ASC_FILENAME=$(basename "${DIST_HADOOP_ASC}")
DEST_DIR=/opt

mkdir -p cache "${DEST_DIR}"
cd cache
wget -c "${DIST_HADOOP}" || true # ignore "HTTP/1.1 416 Requested Range Not Satisfiable" error if the file is already fully retrieved
wget "${DIST_HADOOP_ASC}"
gpg --verify "${DIST_HADOOP_ASC_FILENAME}" "${DIST_HADOOP_FILENAME}"
tar -zxf "${DIST_HADOOP_FILENAME}" -C "${DEST_DIR}"
rm "${DIST_HADOOP_ASC_FILENAME}" "${DIST_HADOOP_FILENAME}"
ln -vs $(basename "${DIST_HADOOP_FILENAME}" .tar.gz) "${HADOOP_HOME}"
# delete native libraries ${HADOOP_HOME}/lib/native/*.so as they require symbols from glibc (e.g., *netgrent) that are not available in musl
# (otherwise, using the libraries results into SIGSEGV, e.g., in "/opt/hadoop/bin/hadoop checknative -a" or in "/opt/hadoop/bin/hdfs datanode"; using glibc in Alpine linux does not help)
# disabling the libraries by "io.native.lib.available=false" property is not possible in Hadoop v3 and anyway, in the previous versions, it did not disable all the libraries
rm -rf "${HADOOP_HOME}/lib/native"
cd -
