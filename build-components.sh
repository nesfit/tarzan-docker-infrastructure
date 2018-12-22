#!/usr/bin/env sh

COMP_DIR=$(dirname "${0}")/components

for I in ${COMP_DIR}/*.yml; do
	docker-compose -f "${I}" run --rm builder || exit 1
done
