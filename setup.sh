#!/usr/bin/env bash


set -e


detect_linux_de() {
    export RUNNING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    export RUNNING_KDE=$([[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] && echo true || echo false)
}
		 

OS=$(uname)
if [ "$OS" = "Darwin" ]; then
    OS="Mac"
elif [ "$OS" = "Linux" ]; then
    detect_linux_de
fi

ascii_art='   ______           __
  / ____/___ ______/ /_  ___ _      __
 / /   / __ `/ ___/ __ \/ _ \ | /| / /
/ /___/ /_/ (__  ) / / /  __/ |/ |/ /
\____/\__,_/____/_/ /_/\___/|__/|__/

'

# Make sure we have ansible collections
ansible-galaxy collection install community.general
ansible-galaxy role install Comcast.sdkman



# Default Selections
export INSTALL_JAVA_ENV=true
export INSTALL_RUBY_ENV=true
export INSTALL_NODEJS_ENV=true
export INSTALL_GO_ENV=true
export INSTALL_PYTHON_ENV=true
export INSTALL_ELIXIR_ENV=ture
export INSTALL_RUST_ENV=true
export INSTALL_FLUTTER_ENV=true

# ask for sudo pass

#gum input --password --value "$password"
read -s -p "SUDO password: " password

export ANSIBLE_BECOME_PASSWORD=$password

echo ">>> Setting up my awesome environment"

ansible-playbook ssh-setup-playbook.yml --ask-vault-pass

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook awesome-setup.yml
#--ask-become-pass
