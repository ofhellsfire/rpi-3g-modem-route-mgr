#!/usr/bin/env bash

source test.vars.bash

function ip() {
  if [[ "${1}" == "addr" && "${2}" == "show" ]]; then
    if [[ "${4}" == "true" ]]; then
      echo 'inet '
    else
      echo ''
    fi
  elif [[ "${1}" == "route" && "${2}" == "list" ]]; then
    if [[ "${4}" == "true" ]]; then
      echo 'default'
    else
      echo ''
    fi
  else
    true
  fi
}

function iptables() {
  cat ${IPTABLES_RULES_FILEPATH}
}
