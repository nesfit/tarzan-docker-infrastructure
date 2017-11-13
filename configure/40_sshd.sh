#!/bin/sh

echo "*** setting up SSHd" >&2

# server keys
ssh-keygen -A
# client keys
for I in dsa ecdsa ed25519 rsa; do
	ssh-keygen -t "${I}" -N '' -f ~/".ssh/id_${I}"
done
cat ~/.ssh/id_*.pub >> ~/.ssh/authorized_keys
