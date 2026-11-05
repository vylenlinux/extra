#!/bin/sh

# dkms scripts for nvidia-open
dkms_install() {
    # shellcheck disable=SC2045
    kernel_version="$(find /usr/lib/modules -maxdepth 1 -type d -iname '*-linux' -printf "%f\n" | sort -V | tail -n1)"

    [ -n "${kernel_version}" ] || kernel_version="$(uname -r)"
    printf "dkms: building nvidia modules for kernel %s...\n" "${kernel_version}"

    dkms add     -m nvidia -v %version% >/dev/null 2>&1
    dkms build   -m nvidia -v %version% -k "${kernel_version}" >/dev/null 2>&1
    dkms install -m nvidia -v %version% -k "${kernel_version}" >/dev/null 2>&1
}

dkms_remove() {
    dkms status -m nvidia | while read -r line; do
        module_version="$(printf '%s\n' "${line}" | sed -n 's#^nvidia/\([^,]*\),.*#\1#p')"
        kernel_version="$(printf "%s\n" "${line}" | sed 's/,//g' | awk '{print $2;}')"

        printf "dkms: remove nvidia-open modules for kernel %s...\n" "${kernel_version}"
        dkms remove -m nvidia -v "${module_version}" -k "${kernel_version}" >/dev/null 2>&1
    done
}

case "${1}" in
    install) dkms_install ;;
    remove) dkms_remove ;;

    *)
        dkms_remove
        dkms_install
    ;;
esac
