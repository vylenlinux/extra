#!/bin/sh

grep -q open /proc/acpi/button/lid/LID/state && exit 0
pm-suspend
