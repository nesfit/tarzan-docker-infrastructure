#!/bin/sh

set -e
set -o pipefail

DIST_ROTARZAN_BASE=https://github.com/rysavy-ondrej/Tarzan

echo "*** clonning and installing ${DIST_ROTARZAN_BASE}" >&2

DIST_ROTARZAN="${DIST_ROTARZAN_BASE}.git"
DEST_DIR=/opt

cd "${DEST_DIR}"
git clone "${DIST_ROTARZAN}" rysavy-ondrej-tarzan
ln -vs rysavy-ondrej-tarzan/Java "${ROTARZAN_HOME}"
cd -
