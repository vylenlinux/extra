#!/bin/sh

# dkms scripts for @name@
dkms_remove() {
    dkms status -m @name@ | while read -r line; do
        module="$(printf "%s\n" "${line}" | sed 's/,//g' | awk '{print $1;}')"
        kernel_version="$(printf "%s\n" "${line}" | sed 's/,//g' | awk '{print $2;}')"

        printf "dkms: remove @name@ modules for kernel %s...\n" "${kernel_version}"
        dkms remove -m "${module}" -k "${kernel_version}" >/dev/null 2>&1
    done
}

dkms_install() {
    # shellcheck disable=SC2045
    kernel_version="$(find /usr/lib/modules -maxdepth 1 -type d -iname '*-linux' -printf "%f\n" | sort -V | tail -n1)"

    [ -n "${kernel_version}" ] || kernel_version="$(uname -r)"
    printf "dkms: building @name@ modules for kernel %s...\n" "${kernel_version}"

    dkms add     -m @name@ -v @version@ -k "${kernel_version}" >/dev/null 2>&1
    dkms build   -m @name@ -v @version@ -k "${kernel_version}" >/dev/null 2>&1
    dkms install -m @name@ -v @version@ -k "${kernel_version}" >/dev/null 2>&1
}

case "${1}" in
    install) dkms_install ;;
    remove) dkms_remove ;;

    *)
        dkms_remove
        dkms_install
    ;;
esac
