FILESEXTRAPATHS_append := ":${THISDIR}/files"

HOSTAPP_HOOKS += " \
  99-resin-grub \
  999-resin-boot-cleaner \
  "

RDEPENDS_${PN} += " \
  os-helpers-fs \
  util-linux-lsblk \
"
