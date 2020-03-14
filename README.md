# RPi 3G Modem Route Mgr [![Build Status](https://travis-ci.com/ofhellsfire/rpi-3g-modem-route-mgr.svg?branch=master)](https://travis-ci.com/github/ofhellsfire/rpi-3g-modem-route-mgr)

## Setup

Setup locally

```
PYTHONUNBUFFERED=1 ansible-playbook ansible/iface-poller.yaml -c local --extra-vars 'pihole_password=<password>'
```

Setup remotely

```
virtualenv --python=$(which python) venv
source venv/bin/activate
pip install ansible
cd ansible
PYTHONUNBUFFERED=1 ansible-playbook iface-poller.yaml -i <RPi IP Address>, --extra-vars 'pihole_password=<password>' --ask-pass --user <user> --ask-become-pass
```

## Running Unit Tests

### Prerequsites

1. Install [bats](https://github.com/sstephenson/bats#installing-bats-from-source) framework

### Running Tests

```
cd tests
bats unit-tests.bats
```
