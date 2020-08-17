#!/bin/bash

SSH_PRIVATE_KEY_PATH=$(pwd)/secrets/vm-private-ssh-key

ansible-playbook kafka.yml -v -i inventory/inventory.yml -b --private-key="$SSH_PRIVATE_KEY_PATH" -t kafka,zookeeper
