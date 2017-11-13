#!/bin/sh

# SSHd
/usr/sbin/sshd

# HDSF
/opt/hadoop/bin/hdfs namenode &
/opt/hadoop/bin/hdfs datanode &
sleep 5

# Spark
/opt/spark/sbin/start-master.sh
/opt/spark/sbin/start-slaves.sh

# Livy
/opt/livy/bin/livy-server

# Cassandra
/opt/cassandra/bin/cassandra -R

# ZooKeeper (in Kafka)
/opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties

# Kafka
/opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties

# Zeppelin
/opt/zeppelin/bin/zeppelin-daemon.sh start

# run args/cmd
exec $@
