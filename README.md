# Docker Infrastructure for TARZAN Platform

(c) 2019-2020 Marek Rychly (rychly@fit.vutbr.cz)

Docker Infrastructure for TARZAN Platform (single-host and multiple-host configurations).

## Technologies

### Distributed Computing

*	[Apache Spark](https://spark.apache.org/docs/latest/) -- batch and stream processing
*	[Apache Hadoop](https://hadoop.apache.org/docs/current/) -- MapReduce batch processing, a platform base

### Data Storage

*	[Apache Cassandra](https://cassandra.apache.org/doc/latest/) -- a NoSQL database
*	[Apache HDFS](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html) -- a file-system

### Communication

*	[Apache Kafka](https://kafka.apache.org/documentation.html) -- a message queue broker

### API / Development Tools

*	[Apache Livy](https://livy.incubator.apache.org/docs/latest/) -- REST API for Apache Spark
*	[Apache Zeppelin](https://zeppelin.apache.org/docs/) -- Web UI for various distributed computation/data processing interpreters and data visualisation
*	[Halyard SDK and WebApps](https://github.com/Merck/Halyard) -- horizontally scalable triple store with support for named graphs
*	[Plaso](https://github.com/log2timeline/plaso) -- tools for automatic creation of timelines to support digital forensic investigators/analysts
*	[Timeline Analyzer](https://github.com/nesfit/timeline-analyzer) -- a framework for efficient analysis of social network profiles and other related data

## Requirements

*	single-node or multi-node cluster
*	homogeneous or heterogeneous hardware (nodes with high strength in CPUs, memory, or stotage)
*	single (linux) or multiple (linux/windows/mac) operating systems
*	each nobe must be able to run [Docker Engine](https://docs.docker.com/engine/)

## Installation

*	[build required components](components/README.md)
*	check [docker-compose.yml](docker-compose.yml) for service volumes that utilise built artefacts of the components
	(these artefacts need to be distributed to particular nodes running the corresponding service containers)

## Deployment

### Single Node -- Zeppelin Standalone

Just run:

~~~sh
./start-services-standalone.sh
~~~

Access [Zeppelin WebUI on localhost](http://localhost:8080/).

### Multiple Nodes -- YARN, HDFS, Spark, Zeppelin

Run the platform services (see the title) including Treafik reverse-proxy server and load-balancer:

~~~sh
./start-services.sh
~~~

Access the services:

*	[Zeppelin WebUI](https://localhost:8443/zeppelin/)
*	[HDFS NameNode](https://localhost:8443/hdfs/)
*	[YARN Resource Manager](https://localhost:8443/yarn/)
*	[Spark History Server](https://localhost:8443/spark/)
*	[Traefik Monitoring](https://localhost:8443/traefik/)

### Docker Swarm

The platform services can run in a Docker Swarm, see comments in [docker-compose.yml](./docker-compose.yml).

## Management

If needed, start also Portainer Docker management to control the platform services:
~~~sh
./start-services-portainer.sh
~~~

Access the service:

*	[Portainer Management](https://localhost:8443/portainer/)

## Usage

The services can be utilised by platform applications/components, e.g., by

*	[Network Traces Analysis Using Apache Spark](https://www.fit.vut.cz/study/thesis/20651/.en) ([GitHub](https://github.com/nesfit/Tarzan)) -- network traces analysis using Apache Spark distributed system
*	[PySpark Plaso](https://github.com/nesfit/pyspark-plaso) -- distributed extraction of timestamps from various files using extractors adapted from the Plaso engine to Apache Spark

### Example: PCAP Analysis in Zeppelin Notebook (Network Traces Analysis Using Apache Spark)

This example demonstrates the Network Traces Analysis Using Apache Spark by using the first platform application/component mentioned above.

Go to the [Zeppelin WebUI](https://localhost:8443/zeppelin/) and create a new Spark note in the Notebook. Then, create and run the following paragraphs:

~~~scala
%spark
import org.ndx.model.Packet;
import org.ndx.model.PacketModel.RawFrame;
import org.ndx.model.Statistics;

val frames = sc.hadoopFile("hdfs://localhost/cap/*.cap",
classOf[org.ndx.pcap.PcapInputFormat],
classOf[org.apache.hadoop.io.LongWritable],
classOf[org.apache.hadoop.io.ObjectWritable])

val packets = frames.map(x=> Packet.parsePacket(x._2.get().asInstanceOf[RawFrame]))

val capinfo = packets.map(x => Statistics.fromPacket(x)).reduce(Statistics.merge)

val flows = packets.map(x=>(x.getFlowString(),x))

val stats = flows.map(x=>(x._1,Statistics.fromPacket(x._2))).reduceByKey(Statistics.merge)

case class PacketStat(firstSeen:java.sql.Date, lastSeen:java.sql.Date, protocol:String, srcAddr:String, srcSel:String, dstAddr:String, dstSel:String, packets:Integer, octets:Long)

val packetStats = stats.map(c => (Packet.flowKeyParse(c._1),c._2)).map(c => PacketStat(
    new java.sql.Date(Statistics.ticksToDate(c._2.getFirstSeen()).getTime()),
    new java.sql.Date(Statistics.ticksToDate(c._2.getLastSeen()).getTime()),
    c._1.getProtocol().toStringUtf8(),
    c._1.getSourceAddress().toStringUtf8(),
    c._1.getSourceSelector().toStringUtf8(),
    c._1.getDestinationAddress().toStringUtf8(),
    c._1.getDestinationSelector().toStringUtf8(),
    c._2.getPackets(),
    c._2.getOctets()
    ))

packetStats.toDF.registerTempTable("packetStats")
~~~

Get all the packet flows.

~~~sql
%sql
select * from packetStats
~~~

Get top 10 flows by the number of packets.

~~~sql
%sql
select * from packetStats order by packets desc limit 10
~~~

Get top 20 flows with respect to octets.

~~~sql
select * from packetStats order by octets desc limit 20
~~~

Get top 20 flows with the longest duration.

~~~sql
select * from packetStats order by (lastSeen-firstSeen) desc limit 20
~~~

Get application flows for a specific application/service.

~~~sql
select * from packetStats where srcSel = "80" order by packets desc limit 20
~~~

Get top 10 source addresses by packets communicated in the flows.

~~~sql
%sql
select srcAddr, sum(packets) from packetStats group by srcAddr order by sum(packets) desc limit 10
~~~

## Acknowledgements

*This work was supported by the Ministry of the Interior of the Czech Republic as a part of the project Integrated platform for analysis of digital data from security incidents VI20172020062.*
