# Ansible Playbook for Kafka Installation

## Prerequisites

* Ansible 2.9.12 (used for testing)

## Quick Start

* Put the SSH-key under the "secrets" folder:
  `$(pwd)/secrets/vm-private-ssh-key`

* Double check inventory `./inventory/inventory.yml`

* Run deployment script `./deploy.sh`

## Expected Results

* Zookeeper is installed and launched in the stand-alone mode

* 3 Kafka Brokers are installed and launched in the cluster mode
