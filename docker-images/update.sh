#!/usr/bin/env sh

for I in docker-*; do
	git -C "${I}" fetch
	git -C "${I}" checkout master
	git -C "${I}" pull --ff-only
done
