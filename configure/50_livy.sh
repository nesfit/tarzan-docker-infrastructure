#!/bin/sh

echo "*** configuring Apache Livy" >&2

LIVY_CONF="${LIVY_HOME}/conf/livy.conf.template"
LIVY_LOGS="${LIVY_HOME}/logs"

mkdir -p "${LIVY_LOGS}"

sed \
	-e "s|^\\(# livy\\.server\\.port = .*\\)\$|\\1\\nlivy.server.port = ${LIVY_PORT}|g" \
	"${LIVY_CONF}" > "${LIVY_CONF%.template}"
