#!/bin/sh

set -e
set -o pipefail

echo "*** setting up SSHd (including a password)" >&2

# password
echo "${GUEST_PASSWORD}" | passwd --stdin "${GUEST_USER}"
# server keys
ssh-keygen -A
# client keys
for I in dsa ecdsa ed25519 rsa; do
	ssh-keygen -t "${I}" -N '' -f ~/".ssh/id_${I}"
done
cat ~/.ssh/id_*.pub >> ~/.ssh/authorized_keys
