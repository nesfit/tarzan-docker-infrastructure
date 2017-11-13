#!/bin/sh

mv hdfs/* "${HADOOP_HOME}/etc/hadoop/"
grep -o 'file://[^<]*' "${HADOOP_HOME}/etc/hadoop/hdfs-site.xml" | cut -d / -f 3- | xargs -r mkdir -p
${HADOOP_HOME}/bin/hdfs namenode -format -nonInteractive
