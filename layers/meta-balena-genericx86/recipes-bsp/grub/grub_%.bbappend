FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://config \
    "

inherit deploy

DEPENDS_append_class-target = " grub-conf grub-native coreutils-native"
RDEPENDS_${PN}_class-native = ""

MBR_IMAGE = "boot.img"
GRUB_IMAGE = "core.img"
GRUB_TARGET = "i386-pc"

GRUB_BUILDIN ?= "biosdisk part_msdos fat search linux"
GRUB_BUILDIN += " gcry_sha512 gcry_rsa"

do_deploy_class-target() {
    mkdir -p ${DEPLOYDIR}/grub/${GRUB_TARGET}
    install -m 644 ${D}/${libdir}/grub/${GRUB_TARGET}/boot.img ${DEPLOYDIR}/grub

    if [ "x${SIGN_API}" = "x" ]; then
        GRUB_PUBKEY_ARG="--pubkey "${B}/pubkey.gpg""
    fi

    grub-mkimage -c ../config -p /grub -d ./grub-core/ -O ${GRUB_TARGET} \
                 -o ${DEPLOYDIR}/grub/${GRUB_IMAGE} ${GRUB_BUILDIN} ${GRUB_PUBKEY_ARG}

    mkdir -p ${DEPLOYDIR}/grub/${GRUB_TARGET}
    cp -r ${D}/${libdir}/grub/${GRUB_TARGET}/*.mod ${DEPLOYDIR}/grub/${GRUB_TARGET}

    if [ "x${SIGN_API}" = "x" ]; then
        cp -r ${D}/${libdir}/grub/${GRUB_TARGET}/*.mod.sig ${DEPLOYDIR}/grub/${GRUB_TARGET}
    fi

    truncate -s 446 ${DEPLOYDIR}/grub/${MBR_IMAGE}
}

do_deploy() {
    :
}

BBCLASSEXTEND = "native"

addtask do_deploy before do_package after do_install
