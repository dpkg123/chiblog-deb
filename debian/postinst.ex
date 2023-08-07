#!/bin/sh
# postinst script for chiblog.
#
# See: dh_installdeb(1).

set -e

# Summary of how this script can be called:
#        * <postinst> 'configure' <most-recently-configured-version>
#        * <old-postinst> 'abort-upgrade' <new version>
#        * <conflictor's-postinst> 'abort-remove' 'in-favour' <package>
#          <new-version>
#        * <postinst> 'abort-remove'
#        * <deconfigured's-postinst> 'abort-deconfigure' 'in-favour'
#          <failed-install-package> <version> 'removing'
#          <conflicting-package> <version>
# for details, see https://www.debian.org/doc/debian-policy/ or
# the debian-policy package.


test -d /opt/chiblog || exit 127
echo "node /opt/chiblog/index.mjs -p 3000" >/usr/bin/chiblog
chmod 755 /usr/bin/chiblog

# dh_installdeb will replace this with shell code automatically
# generated by other debhelper scripts.

#DEBHELPER#

exit 0
