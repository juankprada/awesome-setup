#!/usr/bin/env bash

echo ">>> Setting up my awesome environment"

ansible-playbook ssh-setup-playbook.yml --ask-vault-pass

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook awesome-setup.yml --ask-become-pass
