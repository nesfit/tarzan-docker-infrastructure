# Docker Infrastructure for TARZAN Platform: Installation Guide

(c) 2019-2020 Marek Rychly (rychly@fit.vutbr.cz)

## Requirements

### Hardware

*	single-node or multi-node cluster
*	homogeneous or heterogeneous hardware (nodes with high strength in CPUs, memory, or stotage)
*	single (linux) or multiple (linux/windows/mac) operating systems

### Software

*	installed [Docker](https://docs.docker.com/get-docker/)
*	installed [docker-compose](https://docs.docker.com/compose/install/#install-compose)

## Setup

*	[build required components](../components/README.md)
*	check [docker-compose.yml](../docker-compose.yml) for service volumes that utilise built artefacts of the components
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

## Acknowledgements

*This work was supported by the Ministry of the Interior of the Czech Republic as a part of the project Integrated platform for analysis of digital data from security incidents VI20172020062.*
