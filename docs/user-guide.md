# Docker Infrastructure for TARZAN Platform: User Guide

(c) 2019-2020 Marek Rychly (rychly@fit.vutbr.cz)

## Usage

The services can be utilised by platform applications/components, e.g., by

*	[Network Traces Analysis Using Apache Spark](https://www.fit.vut.cz/study/thesis/20651/.en) ([GitHub](https://github.com/nesfit/Tarzan)) -- network traces analysis using Apache Spark distributed system
*	[PySpark Plaso](https://github.com/nesfit/pyspark-plaso) -- distributed extraction of timestamps from various files using extractors adapted from the Plaso engine to Apache Spark

## Example: PCAP Analysis in Zeppelin Notebook (Network Traces Analysis Using Apache Spark)

This example demonstrates the Network Traces Analysis Using Apache Spark by using the first platform application/component mentioned above.
The example is based on [the original sample](https://github.com/nesfit/Tarzan/blob/master/Java/zeppelin-note) from [the GitHub repository](https://github.com/nesfit/Tarzan).

Go to the [Zeppelin WebUI](https://localhost:8443/zeppelin/) and create a new Spark note in the Notebook. Then, create and run the following paragraphs:

~~~scala
%spark
import org.ndx.tshark.scala.TShark
val packets = TShark.getPackets(sc, "hdfs://namenode/data/http_m2.json")
val smtpPackets = TShark.getPackets(sc, "hdfs://namenode/data/smtp.json")
TShark.registerHttpHostnames("httpHostnames", packets, spark)
TShark.registerKeywords("keywords", packets, List("sme.sk", "site.the.cz"), spark, sc)
TShark.registerDnsData("dnsData", packets, spark)
TShark.registerFlowStatistics("flowStatistics", packets, spark)
TShark.registerFlowStatistics("smtpFlowStatistics", smtpPackets, spark)
~~~

Get URLs from HTTP headers.

~~~sql
%sql
select url, count(*) from httpHostnames group by url
~~~

Get keywords.
~~~sql
%sql
select keyword, count from keywords
~~~

Get DNS query record types.

~~~sql
%sql
select recordType, count(*) from dnsData where recordType != "" group by recordType
~~~

Get a timeline of flows (flows/time).

~~~sql
%sql
select from_unixtime(unix_timestamp(first, 'yyyy-MM-dd HH:mm:ss.SSS'), 'yyyy-MM-dd HH:mm'), count(*)
from flowStatistics group by first order by first
~~~

Get a timeline of packets (packets/time).

~~~sql
%sql
select from_unixtime(unix_timestamp(first, 'yyyy-MM-dd HH:mm:ss.SSS'), 'yyyy-MM-dd HH:mm'), sum(packets)
from flowStatistics group by first order by first
~~~

Get a timeline of data (bytes/time).

~~~sql
%sql
select from_unixtime(unix_timestamp(first, 'yyyy-MM-dd HH:mm:ss.SSS'), 'yyyy-MM-dd HH:mm'), sum(bytes)
from flowStatistics group by first order by first
~~~

Get a timeline of HTTP traffic (packets/time).

~~~sql
%sql
select from_unixtime(unix_timestamp(first, 'yyyy-MM-dd HH:mm:ss.SSS'), 'yyyy-MM-dd HH:mm') as time, sum(packets)
from flowStatistics where service == "80" group by time order by time
~~~

Get a timeline of HTTPS traffic (packets/time).

~~~sql
%sql
select from_unixtime(unix_timestamp(first, 'yyyy-MM-dd HH:mm:ss.SSS'), 'yyyy-MM-dd HH:mm') as time, sum(packets)
from flowStatistics where service == "443" group by time order by time
~~~

Get a size of HTTP and HTTPS traffic.

~~~sql
%sql
select service, sum(packets) from flowStatistics where service == "80" or service == "443" group by service
~~~

Get a size of LAN and WAN traffic.

~~~sql
%sql
select lanWan, count(*) from flowStatistics where lanWan == "lan" or lanWan == "wan" group by lanWan
~~~

Get domains from DNS requests.

~~~sql
%sql
select domain, count(*) from dnsData where domain != "" and isResponse == false group by domain limit 10
~~~

Get the email traffic structure.

~~~sql
%sql
select email, sum(bytes) from smtpFlowStatistics where email != "" group by email
~~~

Get web-servers producing the most traffic.

~~~sql
%sql
select srcAddr, sum(bytes) from flowStatistics where srcPort == "80" or srcPort == "443" group by srcAddr limit 10
~~~

Get end-points receiving the most traffic.

~~~sql
%sql
select dstAddr, sum(bytes) from flowStatistics group by dstAddr limit 10
~~~

Get SMTP/SMTPS clients producing the most traffic.

~~~sql
%sql
select srcAddr, sum(bytes) from smtpFlowStatistics
where (email == "smtp" or email == "smtps") and direction == "up" group by srcAddr limit 10
~~~

Get SMTP/SMTPS servers producing the most traffic.

~~~sql
%sql
select srcAddr, sum(bytes) from smtpFlowStatistics
where (email == "smtp" or email == "smtps") and direction == "down" group by srcAddr limit 10
~~~

## Example: Time-line Analysis of Events Extracted from Files in a File-system Dump (PySpark Plaso)

The TARZAN Docker Infrastructure is utilized in [PySpark Plaso](https://github.com/nesfit/pyspark-plaso) to deploy system components.

For sample deployment, see [docker-compose.yml files](https://github.com/nesfit/pyspark-plaso/tree/master/deployment/docker-compose) in the PySpark Plaso project.

The infrastructure components are also utilized in [the (alternative) Kubernetes deployment](https://github.com/nesfit/pyspark-plaso/tree/master/deployment/kubernetes).

## Acknowledgements

*This work was supported by the Ministry of the Interior of the Czech Republic as a part of the project Integrated platform for analysis of digital data from security incidents VI20172020062.*
