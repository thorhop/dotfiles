#!/run/current-system/sw/bin/bash
set -e
ping -c 1 -n $1
dmesg -E
dmesg -n debug
modprobe netconsole "netconsole=@/,7777@${1}/"
