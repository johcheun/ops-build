SUMMARY = "OpenSwitch CLI"
LICENSE = "GPL-2.0 & LGPL-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=81bcece21748c91ba9992349a91ec11d\
                    file://COPYING.LIB;md5=01ef24401ded36cd8e5d18bfe947240c"

DEPENDS = "ops-utils ops-ovsdb"

SRC_URI = "git://git.openswitch.net/openswitch/ops-cli;protocol=http \
"

SRCREV = "072a8459c9573849884d692dc2f1a2457809fe05"

# When using AUTOREV, we need to force the package version to the revision of git
# in order to avoid stale shared states.
PV = "git${SRCPV}"

S = "${WORKDIR}/git"

EXTRA_OECONF = "--enable-user=root --enable-group=root \
 --enable-ovsdb --enable-vtysh\
"

inherit openswitch autotools pkgconfig
