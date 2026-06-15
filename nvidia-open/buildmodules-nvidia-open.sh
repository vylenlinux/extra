#!/bin/sh

# dkms scripts for nvidia
dkms_remove() {
    dkms status -m nvidia | while read -r line; do
        module=$(echo "${line}" | sed 's/,//g' | awk '{print $1}')
        kerver=$(echo "${line}" | sed 's/,//g' | awk '{print $2}')

        echo "dkms: remove nvidia modules for kernel ${kerver}..."
        dkms remove -m "${module}" -k "${kerver}" >/dev/null 2>&1
    done
}

dkms_install() {
    # shellcheck disable=SC2045
    kernver=$(find /lib/modules -maxdepth 1 -type d -iname '*-linux' -printf "%f\n" | sort -V | tail -n1)

    [ -n "${kernver}" ] || kernver=$(uname -r)
    echo "dkms: building nvidia modules for kernel ${kernver}..."

    dkms add     -m @name@ -v @version@ -k "${kernver}" >/dev/null 2>&1
    dkms build   -m @name@ -v @version@ -k "${kernver}" >/dev/null 2>&1
    dkms install -m @name@ -v @version@ -k "${kernver}" >/dev/null 2>&1
}

case "${1}" in
    install) dkms_install ;;
    remove) dkms_remove ;;

    *)
        dkms_remove
        dkms_install
    ;;
esac
