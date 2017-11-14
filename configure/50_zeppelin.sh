#!/bin/sh

echo "*** configuring Apache Zeppelin" >&2

ZEPPELIN_CONF="${ZEPPELIN_HOME}/conf/zeppelin-site.xml.template"
ZEPPELIN_ENV="${ZEPPELIN_HOME}/conf/zeppelin-env.sh"

sed \
	-e "/<name>zeppelin.server.port</,/<value>/{s|<value>[^<]*</value>|<value>${ZEPPELIN_PORT}</value>|}" \
	-e '/<\/configuration>/d' \
	"${ZEPPELIN_CONF}" >"${ZEPPELIN_CONF%.template}"

cat <<END >> "${ZEPPELIN_CONF%.template}"
<property>
  <name>cassandra.native.port</name>
  <value>${CASSANDRA_NATTRANS_PORT}</value>
  <description>The port where to bootstrap Cassandra Java Driver to connect to cassandra.hosts.</description>
</property>
<property>
  <name>hdfs.url</name>
  <value>http://localhost:${HDFS_NAMENODE_WEBUI_PORT}/webhdfs/v1/</value>
  <description>The URL for WebHDFS.</description>
</property>
<property>
  <name>master</name>
  <value>${SPARK_MASTER}</value>
  <description>Spark master URI.</description>
</property>
<property>
  <name>zeppelin.livy.url</name>
  <value>http://localhost:${LIVY_PORT}</value>
  <description>URL where Livy server is running.</description>
</property>
</configuration>
END

cat <<END > "${ZEPPELIN_ENV}"
#!/usr/bin/env bash
export JAVA_HOME=${JAVA_HOME}
export MASTER=${SPARK_MASTER}
END
chmod 755 "${ZEPPELIN_ENV}"

${ZEPPELIN_HOME}/bin/install-interpreter.sh --all
