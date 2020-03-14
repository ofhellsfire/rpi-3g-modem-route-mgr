#!/usr/bin/env bash

# case 1: poll, if eth1 is not found, then ensure that: ip for eth0 is set, port forwarding disabled and eth0 is in default route
# case 2: poll, otherwise ensure that: ip for eth0 is set, port forwarding enabled and eth0 is removed from default route

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi
. "${DIR}/iface.vars.sh"
. "${DIR}/iface.library.sh"


function print_help() {
echo "Script Name: ${0:2} [--eth0-ip IPADDRESS --poll-timeout SECONDS]

Simple Service Helper Utility For Huawei 3G Modem With RaspberryPI

Usage:
-h, --help                 Print usage

OPTIONS
--eth0-ip                  IP address for eth0 interface
--poll-timeout             Poll cycle timeout (in seconds)
"
}

function parse_args() {
  while true; do
    case "$1" in
      -h | --help ) print_help; exit 0 ;;
      --eth0-ip ) ETHERNET_IP_ADDR=${2}; shift 2 ;;
      --poll-timeout ) TIMEOUT=${2}; shift 2 ;;
      * ) break ;;
    esac
  done
}

function main() {

  parse_args $@

  while true; do
    echo $(date)
    poll
    echo ''
    sleep ${TIMEOUT}
  done

}

main $@
