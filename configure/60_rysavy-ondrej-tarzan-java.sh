#!/bin/sh

set -e
set -o pipefail

DIST_ROTARZAN_BASE=https://github.com/rysavy-ondrej/Tarzan

echo "*** configuring ${DIST_ROTARZAN_BASE}" >&2

SPARK_DEF_CONF="${SPARK_HOME}/conf/spark-defaults.conf"
ROTARZAN_NDX_SPARK_SHELL="${ROTARZAN_HOME}/ndx-spark-shell/target/ndx-spark-shell"

cd "${ROTARZAN_HOME}"
mvn package
cd -

# clean Maven cache for downloaded artefacts
rm -rf ~/.m2/repository

# look for the artefact (its filename depends on the package version)
ROTARZAN_NDX_SPARK_SHELL=$(ls -d "${ROTARZAN_NDX_SPARK_SHELL}"*.jar | tr '\n' ',' | sed 's/,$//')

if grep -q 'spark.jars\s' "${SPARK_DEF_CONF}"; then
	sed -i "s|^\\(spark.jars\\s.*\\)\$|\\1,${ROTARZAN_NDX_SPARK_SHELL}|" "${SPARK_DEF_CONF}"
else
	echo "spark.jars ${ROTARZAN_NDX_SPARK_SHELL}" >> "${SPARK_DEF_CONF}"
fi
