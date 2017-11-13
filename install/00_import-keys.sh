#!/bin/sh

for I in keys/* ; do
	gpg --import "${I}"
done
