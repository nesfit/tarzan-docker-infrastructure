#!/bin/sh

set -e
set -o pipefail

echo "*** copying executable scripts" >&2

mv bin/* /usr/local/bin/
