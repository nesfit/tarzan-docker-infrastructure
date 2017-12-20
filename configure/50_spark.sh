#!/bin/sh

set -e
set -o pipefail

echo "*** configuring Apache Spark" >&2

SPARK_SLAVES_FILE="${SPARK_HOME}/conf/slaves"
SPARK_DEF_CONF="${SPARK_HOME}/conf/spark-defaults.conf"
SPARK_ENV="${SPARK_HOME}/conf/spark-env.sh"

echo "localhost" >> ${SPARK_SLAVES_FILE}
echo "spark.master ${SPARK_MASTER_URL}" >> ${SPARK_DEF_CONF}
cat <<END > "${SPARK_ENV}"
#!/usr/bin/env bash
JAVA_HOME=${JAVA_HOME}
SPARK_DIST_CLASSPATH=\$(${HADOOP_HOME}/bin/hadoop classpath)
END
chmod 755 "${SPARK_ENV}"

# Spark shell scripts require ps from procps, they are not compatible with Busybox ps (unknown parameter 'p')
# Spark shell scripts require nohup from coreutils, they are not compatible with Busybox nohup (cannot interpret parameter '--')
