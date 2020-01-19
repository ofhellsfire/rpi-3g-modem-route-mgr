#!/usr/bin/env bats

source ../iface.vars.sh
source ../iface.library.sh

load mocks
load helpers

@test "interface is setup with IP address" {
  run is_iface_setup true
  [ "${status}" -eq 0 ]
}

@test "interface is not setup with IP address" {
  run is_iface_setup false
  [ "${status}" -eq 1 ]
}

@test "forwarding is enabled" {
  create_iptables_rules
  run is_forwarding_enabled
  [ "${status}" -eq 0 ]
}

@test "forwarding is disabled" {
  delete_iptables_rules
  run is_forwarding_enabled
  [ "${status}" -eq 1 ]
}

@test "interface is presented in default route" {
  ETHERNET_IFACE=true
  run is_eth0_in_default_route
  [ "${status}" -eq 0 ]
}

@test "interface is not presented in default route" {
  ETHERNET_IFACE=false
  run is_eth0_in_default_route
  [ "${status}" -eq 1 ]
}

@test "ensure eth0 IP if eth0 is without IP" {
  ETHERNET_IFACE=false
  run ensure_eth0_ip
  [ "${status}" -eq 0 ]
  [ "${output}" = "IP address has been set for eth0 as '${ETHERNET_IP_ADDR}'" ]
}

@test "do nothing if eth0 has IP" {
  ETHERNET_IFACE=true
  run ensure_eth0_ip
  [ "${status}" -eq 0 ]
  [ "${lines[1]}" = "eth0 is setup: Nothing to do" ]
}

@test "enable forwarding & remove eth0 from default route if eth1 is setup" {
  ETHERNET_IFACE=true
  USB_MODEM_IFACE=true
  delete_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[1]}" = "forwarding has been enabled" ]
  [ "${lines[3]}" = "eth0 has been removed from default route" ]
}

@test "do nothing if eth1 is setup" {
  ETHERNET_IFACE=false
  USB_MODEM_IFACE=true
  create_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[4]}" = "forwarding is enabled: Nothing to do" ]
  [ "${lines[5]}" = "eth0 is not in default route: Nothing to do" ]
}

@test "enable forwarding only if eth1 is setup" {
  ETHERNET_IFACE=false
  USB_MODEM_IFACE=true
  delete_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[1]}" = "forwarding has been enabled" ]
  [ "${lines[2]}" = "eth0 is not in default route: Nothing to do" ]
}

@test "remove eth0 from default route only if eth1 is setup" {
  ETHERNET_IFACE=true
  USB_MODEM_IFACE=true
  create_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[4]}" = "forwarding is enabled: Nothing to do" ]
  [ "${lines[6]}" = "eth0 has been removed from default route" ]
}

@test "disable forwarding & add eth0 to default route if eth1 is not setup" {
  ETHERNET_IFACE=false
  USB_MODEM_IFACE=false
  create_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[12]}" = "forwarding has been disabled" ]
  [ "${lines[13]}" = "eth0 has been added to default route" ]
}

@test "do nothing if eth1 is not setup" {
  ETHERNET_IFACE=true
  USB_MODEM_IFACE=false
  delete_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "forwarding is disabled: Nothing to do" ]
  [ "${lines[2]}" = "eth0 is in default route: Nothing to do" ]
}

@test "disable forwarding only if eth1 is not setup" {
  ETHERNET_IFACE=true
  USB_MODEM_IFACE=false
  create_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[12]}" = "forwarding has been disabled" ]
  [ "${lines[14]}" = "eth0 is in default route: Nothing to do" ]
}

@test "add eth0 to default route only if eth1 is not setup" {
  ETHERNET_IFACE=false
  USB_MODEM_IFACE=false
  delete_iptables_rules
  run configure_forwarding_and_routing
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "forwarding is disabled: Nothing to do" ]
  [ "${lines[1]}" = "eth0 has been added to default route" ]
}

@test "check help() presence" {
  cd ..
  run ./iface-poller.sh --help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Script Name: iface-poller.sh [--eth0-ip IPADDRESS --poll-timeout SECONDS]" ]
  [ "${lines[1]}" = "Simple Service Helper Utility For Huawei 3G Modem With RaspberryPI" ]
  [ "${lines[2]}" = "Usage:" ]
  [ "${lines[3]}" = "-h, --help                 Print usage" ]
  [ "${lines[4]}" = "OPTIONS" ]
  [ "${lines[5]}" = "--eth0-ip                  IP address for eth0 interface" ]
  [ "${lines[6]}" = "--poll-timeout             Poll cycle timeout (in seconds)" ]
}
