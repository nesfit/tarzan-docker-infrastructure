#!/bin/sh

set -e
set -o pipefail

echo "*** importing release keys" >&2

for I in keys/* ; do
	gpg --import "${I}"
done
