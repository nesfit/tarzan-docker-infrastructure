#!/bin/sh

SPARK_SLAVES_FILE="${SPARK_HOME}/conf/slaves"
SPARK_DEF_CONF="${SPARK_HOME}/conf/spark-defaults.conf"
SPARK_ENV="${SPARK_HOME}/conf/spark-env.sh"

echo "localhost" >> ${SPARK_SLAVES_FILE}
echo "spark.master ${SPARK_MASTER}" >> ${SPARK_DEF_CONF}
cat <<END > "${SPARK_ENV}"
#!/usr/bin/env bash
JAVA_HOME=${JAVA_HOME}
SPARK_DIST_CLASSPATH=\$(${HADOOP_HOME}/bin/hadoop classpath)
END
chmod 755 "${SPARK_ENV}"
