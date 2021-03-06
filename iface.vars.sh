#!/usr/bin/env bash

TIMEOUT=10

ETHERNET_IFACE='eth0'
USB_MODEM_IFACE='eth1'

ETHERNET_IP_ADDR='192.168.53.1'

IPRULE_NAT="POSTROUTING -o ${USB_MODEM_IFACE} -j MASQUERADE"
IPRULE_FORWARD_EXT="FORWARD -i ${ETHERNET_IFACE} -o ${USB_MODEM_IFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT"
IPRULE_FORWARD="FORWARD -i ${ETHERNET_IFACE} -o ${USB_MODEM_IFACE} -j ACCEPT"
