#!/bin/sh

# dkms scripts for nvidia-open
dkms_install() {
    # shellcheck disable=SC2045
    kernel_version="$(find /usr/lib/modules -maxdepth 1 -type d -iname '*-linux' -printf "%f\n" | sort -V | tail -n1)"

    [ -n "${kernel_version}" ] || kernel_version="$(uname -r)"
    printf "dkms: building nvidia modules for kernel %s...\n" "${kernel_version}"

    dkms add     -m nvidia/%version%
    dkms build   -m nvidia/%version% -k "${kernel_version}"
    dkms install -m nvidia/%version% -k "${kernel_version}"
}

dkms_remove() {
    dkms remove -m nvidia --all
}

case "${1}" in
    install) dkms_install ;;
    remove) dkms_remove ;;

    *)
        dkms_remove
        dkms_install
    ;;
esac
