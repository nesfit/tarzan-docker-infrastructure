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

### Single Node

Just run:

~~~sh
docker-compose -f docker-compose-single.yml up
~~~

### Cluster

TBA

## Management

TBA

## Usage

TBA
