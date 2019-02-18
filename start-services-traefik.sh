#!/usr/bin/env bash

exec docker-compose -p boot -f docker-compose-traefik.yml ${@:-up}
