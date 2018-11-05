#!/usr/bin/env bash

function is_iface_setup() {
  iface=${1}
  ip addr show dev ${iface} | grep 'inet '
  return
}

function is_eth1_setup() {
  is_iface_setup ${USB_MODEM_IFACE}
  return
}

function is_eth0_ip_set() {
  is_iface_setup ${ETHERNET_IFACE}
  return
}

function set_ip_eth0() {
  ip addr add ${ETHERNET_IP_ADDR}/24 dev ${ETHERNET_IFACE}
}

function disable_forwarding() {
  iptables -t nat -D ${IPRULE_NAT}
  iptables -D ${IPRULE_FORWARD_EXT}
  iptables -D ${IPRULE_FORWARD}
}

function enable_forwarding() {
  iptables -t nat -A ${IPRULE_NAT}
  iptables -A ${IPRULE_FORWARD_EXT}
  iptables -A ${IPRULE_FORWARD}
}

function is_forwarding_enabled() {
  iptables -t nat -S | grep -- "-A ${IPRULE_NAT}" && \
  iptables -S | grep -- "-A ${IPRULE_FORWARD_EXT}" && \
  iptables -S | grep -- "-A ${IPRULE_FORWARD}"
  return
}

function add_eth0_to_default_route() {
  ip route add default via ${ETHERNET_IP_ADDR} dev ${ETHERNET_IFACE} src ${ETHERNET_IP_ADDR} metric 202
}

function remove_eth0_from_default_route() {
  ip route del default dev ${ETHERNET_IFACE}
}

function is_eth0_in_default_route() {
  ip route list dev ${ETHERNET_IFACE} | grep default
  return
}

function ensure_eth0_ip() {
  if ! is_eth0_ip_set; then
    set_ip_eth0
    echo "IP address has been set for eth0 as '${ETHERNET_IP_ADDR}'"
  else
    echo "eth0 is setup: Nothing to do"
  fi
}

function configure_forwarding_and_routing() {
  if is_eth1_setup; then
    if ! is_forwarding_enabled; then
      enable_forwarding
      echo "forwarding has been enabled"
    else
      echo "forwarding is enabled: Nothing to do" 
    fi
    if is_eth0_in_default_route; then
      remove_eth0_from_default_route
      echo "eth0 has been removed from default route"
    else
      echo "eth0 is not in default route: Nothing to do"
    fi
  else
    if is_forwarding_enabled; then
      disable_forwarding
      echo "forwarding has been disabled"
    else
      echo "forwarding is disabled: Nothing to do"
    fi
    if ! is_eth0_in_default_route; then
      add_eth0_to_default_route
      echo "eth0 has been added to default route"
    else
      echo "eth0 is in default route: Nothing to do"
    fi
  fi
}

function poll() {
  ensure_eth0_ip
  configure_forwarding_and_routing
}
