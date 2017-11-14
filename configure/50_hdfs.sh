#!/bin/sh

echo "*** configuring Apache Hadoop HDFS" >&2

HDFS_CONF="${HADOOP_HOME}/etc/hadoop/hdfs-site.xml"

mv hdfs/* "${HADOOP_HOME}/etc/hadoop/"
sed -i \
	-e "/<name>dfs.namenode.http-address</,/<value>/{s|<value>[^<]*</value>|<value>0.0.0.0:${HDFS_NAMENODE_WEBUI_PORT}</value>|}" \
	"${HDFS_CONF}"
grep -o 'file://[^<]*' "${HDFS_CONF}" | cut -d / -f 3- | xargs -r mkdir -p
${HADOOP_HOME}/bin/hdfs namenode -format -nonInteractive