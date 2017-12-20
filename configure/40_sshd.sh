#!/bin/sh

set -e
set -o pipefail

echo "*** setting up SSHd (including a password)" >&2

# password
passwd "${GUEST_USER}" <<END
${GUEST_PASSWORD}
${GUEST_PASSWORD}
END
# server keys
ssh-keygen -A
# client keys
for I in dsa ecdsa ed25519 rsa; do
	ssh-keygen -t "${I}" -N '' -f ~/".ssh/id_${I}"
done
cat ~/.ssh/id_*.pub >> ~/.ssh/authorized_keys
# enable auto-updates of < global host key database
cat >>/etc/ssh/ssh_config <<END

Host localhost 127.* ::1
	CheckHostIP no
	HashKnownHosts no
	StrictHostKeyChecking no
	UpdateHostKeys yes
END
