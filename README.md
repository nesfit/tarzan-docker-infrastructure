# TARZAN Platform for Docker

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
docker-compose -f docker-compose-standalone.yml up
~~~

Access [Zeppelin WebUI on localhost](http://localhost:8080/).

### Multiple Nodes -- YARN, HDFS, Spark, Zeppelin

Run the platform Treafik reverse-proxy server, services (see the title), and load-balancer, and Portainer Docker management:

~~~sh
docker-compose -f docker-compose-traefik.yml up
docker-compose -f docker-compose.yml up
docker-compose -f docker-compose-portainer.yml up
~~~

Access the services:

*	[YARN Resource Manager](http://localhost:8080/yarn/)
*	[HDFS NameNode](http://localhost:8080/hdfs/)
*	[Zeppelin WebUI](http://localhost:8080/zeppelin/)
*	[Spark History Server](http://localhost:8080/spark/)
*	[Traefik Monitoring](http://localhost:8080/traefik/)
*	[Portainer Management](http://localhost:8080/portainer/)

### Docker Swarm

TBA

## Management

TBA

## Usage

TBA
