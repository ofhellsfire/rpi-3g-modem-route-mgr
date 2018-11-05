#!/usr/bin/env bash

source ../iface.vars.sh
source test.vars.bash


function create_iptables_rules() {
  cat <<EOF | tee ${IPTABLES_RULES_FILEPATH}
    -A ${IPRULE_NAT}
    -A ${IPRULE_FORWARD_EXT}
    -A ${IPRULE_FORWARD}
EOF
}

function delete_iptables_rules() {
  cat <<EOF | tee ${IPTABLES_RULES_FILEPATH}

EOF
}
