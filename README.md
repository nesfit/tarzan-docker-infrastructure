# TARZAN Platform Docker Repository

## Components

### Distributed Computing

* [Apache Spark](https://spark.apache.org/docs/latest/) -- batch and stream processing
* [Apache Hadoop](https://hadoop.apache.org/docs/current/) -- MapReduce batch processing, a platform base

### Data Storage

* [Apache Cassandra](https://cassandra.apache.org/doc/latest/) -- a NoSQL database
* [Apache HDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html) -- a file-system

### Communication

* [Apache Kafka](https://kafka.apache.org/documentation.html) -- a message queue broker

### API / Development Tools

* [Apache Livy](https://livy.incubator.apache.org/docs/latest/) -- REST API for Apache Spark
* [Apache Zeppelin](https://zeppelin.apache.org/docs/) -- Web UI for various distributed computation/data processing interpreters and data visualisation

## Applications

* [rysavy-ondrej/Tarzan](https://github.com/rysavy-ondrej/Tarzan) -- not only packet analysis in Spark

## End-users

### Set-up the Environment

* [get Docker](https://www.docker.com/get-docker)
* [get GNU Make](https://www.gnu.org/software/make/)
  * [Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm#download)

### Download and Use the Docker Image

Pull the latest Docker image of the platform:

~~~sh
make REMOTE=1 pull-latest
~~~

Run the latest Docker image for a single host (where `X` is any non-empty identifier; the target name will be utilised as a name and a hostname of the running image):
~~~sh
make single-latestX
~~~

Alternatively, without GNU make, you can run the Docker image `registry.gitlab.com/rychly/tarzan-platform-docker:latest` directly (or by `make shell-latestX`)
and use its script `/usr/local/bin/tarzan-start-single` to start applications for the single host.

To stop the running image, exit the shell (by `exit`).

### Check IPs/Ports of the Running Image

* list IP addresses of the currently running platform images: `make show-ips`
* list port numbers where applications should run in the images: `make desc-ports`
* list port forwardings from the running platform images: `make show-ports`

### Use the Platform Applications

Let `172.17.0.2` be an IP address of the running platform image. Then, the following are Web UI addresses (with default port numbers) of the platform applications:

* Apache Spark
  * [Spark Master](http://172.17.0.2:8080/)
  * [Spark Slave](http://172.17.0.2:8081/)
* Apache Hadoop / HDFS
  * `hadoop`
  * [HDFS NameNode](http://172.17.0.2:50070/)
* Apache Cassandra
  * CQL Shell for Apache Cassandra: `cqlsh`
* Apache Kafka
  * sender/receiver from/to stdout: `kafka-console-producer.sh` and `kafka-console-consumer.sh`
  * message queues management: `kafka-topics.sh`
* [Apache Livy](http://172.17.0.2:8998/)
* [Apache Zeppelin](http://172.17.0.2:8082/)

These applications can be accessed also at forwarded local port numbers (see the section on IPs/Ports).

### Report Issues to a Service Desk

* report [by email](mailto:incoming+rychly/tarzan-platform-docker@gitlab.com)
* or see [known issues](https://gitlab.com/rychly/tarzan-platform-docker/issues/service_desk)

## Developers

TBA
