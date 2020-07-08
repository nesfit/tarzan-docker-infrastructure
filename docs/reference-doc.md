# Docker Infrastructure for TARZAN Platform: Reference Documentation

(c) 2019-2020 Marek Rychly (rychly@fit.vutbr.cz)

## Infrastructure Definition Files

The infrastructured is defined in `docker-compose.yml` files:

*	[docker-compose.yml](../docker-compose.yml) -- a multiple-node deployment with YARN scheduler, HDFS storage, Spark engine, and Zeppelin WebUI
*	[docker-compose-standalone.yml](../docker-compose-standalone.yml) -- a single-node deployment of a standalone Zeppelin WebUI with integrated Spark engine
*	[docker-compose-traefik.yml](../docker-compose-traefik.yml) -- a reverse proxy server for the multiple-node deployment to publish all the services in the one end-point
*	[docker-compose-portainer.yml](../docker-compose-portainer.yml) -- the Portainer Docker management tool to control the platform services above

For details of those deployments, see the corresponding `docker-compose.yml` files above.

## Acknowledgements

*This work was supported by the Ministry of the Interior of the Czech Republic as a part of the project Integrated platform for analysis of digital data from security incidents VI20172020062.*
