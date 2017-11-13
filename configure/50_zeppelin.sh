#!/bin/sh

echo "*** configuring Apache Zeppelin" >&2

ZEPPELIN_CONF="${ZEPPELIN_HOME}/conf/zeppelin-site.xml.template"

sed \
	-e "/<name>zeppelin.server.port</,/<value>/{s|<value>[^<]*</value>|<value>${ZEPPELIN_PORT}</value>|}" \
	-e "s|\\(</configuration>\\)|<property><name>cassandra.native.port</name><value>${CASSANDRA_NATTRANS_PORT}</value><description>The port where to bootstrap Cassandra Java Driver to connect to cassandra.hosts.</description>/property><property><name>hdfs.url</name><value>http://localhost:${HDFS_NAMENODE_WEBUI_PORT}/webhdfs/v1/</value><description>The URL for WebHDFS.</description>/property><property><name>master</name><value>${SPARK_MASTER}</value><description>Spark master uri.</description></property><property><name>zeppelin.livy.url</name><value>http://localhost:${LIVY_PORT}</value><description>URL where livy server is running.</description></property>\\1|" \
	"${ZEPPELIN_CONF}" > $(basename "${ZEPPELIN_CONF}" .template)
