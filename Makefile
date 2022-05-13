override SHELL := /bin/bash

.PHONY: lxd_install
lxd_install: ## LXD Installation
	sudo snap install lxd

## LXD Configuration
lxd_configuration: single-node.preseed
	cat single-node.preseed | lxd init --preseed

.PHONY: lxc_default_containers
lxc_default_containers: ## LXC default containers
	lxc launch -p default ubuntu:20.04 name-container

.PHONY: lxc_containers
lxc_containers: ## LXC containers
	lxc launch -p default -p macvlan ubuntu:20.04 name-container

.PHONY: a_install
a_install: ## Ansible installation
	sudo python -m pip install ansible

## Teleport Installation
t_install: common.yml
	ansible-playbook -i hosts common.yml

## Teleport Host Installation
t_host_install: teleport-host.yml
	ansible-playbook -i hosts teleport-host.yml

## Teleport Nodes Installation
t_node_install: node.yml
	ansible-playbook -i hosts node.yml

.PHONY: clean
clean: ## Clean .o
		rm -f *.o