#!/bin/bash

# ask for sudo pass
read -s -p "SUDO password: " password

export ANSIBLE_BECOME_PASSWORD=$password

echo ">>> Setting up my awesome environment"

ansible-playbook ssh-setup-playbook.yml --ask-vault-pass

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook awesome-setup.yml --skip-tags "update"
#--ask-become-pass
