#!/usr/bin/env bash

BASE="${0%.sh}" COMPOSE_FILE="${BASE//start-services/docker-compose}.yml"
exec docker-compose -f "${COMPOSE_FILE}" ${@:-up}
