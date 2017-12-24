#!/bin/sh

set -e
set -o pipefail

echo "*** copying executable scripts and setting PATH in the profile" >&2

mv bin/* /usr/local/bin/

PATH_PROFILE="/etc/profile.d/path.sh"
cat >"${PATH_PROFILE}" <<END
#!/bin/sh

export PATH="\${PATH}:${PATH_FOR_PROFILE}"
END
chmod 755 "${PATH_PROFILE}"
