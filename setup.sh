#!/usr/bin/env bash


set -e


# Checks if gum is installed
check_gum() {
    if command -v gum -v >/dev/null 2>&1; then
	return 0
    else
	return 1
    fi
}

install_gum_macos() {
    if ! command -v brew >/dev/null 2>&1; then
	echo "Hombre is not installed. Installing Homebrew first..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install gum
}


# Function to install Ruby on Ubuntu using apt-get
install_gum_ubuntu() {
    sudo apt-get update > /dev/null
    sudo apt-get install -y gum >/dev/null
    
}

install_gum_fedora() {
    sudo dnf install -y gum >/dev/null
}


detect_linux_de() {
    export RUNNING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    export RUNNING_KDE=false
}
		 

OS=$(uname)
if [ "$OS" = "Darwin" ]; then
    OS="Mac"
    install_gum_macos
elif [ "$OS" = "Linux" ]; then
    detect_linux_de
    if [ -f /etc/os-release ]; then
	. /etc/os-release
	case "$ID" in
	    ubuntu)
		OS="Ubuntu"
		install_gum_ubuntu
	    ;;
	    fedora)
		OS="Fedora"
		install_gum_fedora
	    ;;
	    *)
		echo "Unsupported distribution"
		exit 1
		;;
	esac
    else
	echo "Unsupported OS."
	exit 1
    fi
fi

ascii_art='   ______           __
  / ____/___ ______/ /_  ___ _      __
 / /   / __ `/ ___/ __ \/ _ \ | /| / /
/ /___/ /_/ (__  ) / / /  __/ |/ |/ /
\____/\__,_/____/_/ /_/\___/|__/|__/

'





# Make sure we have ansible collections
ansible-galaxy collection install community.general




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

gum input --password --value "$password"
#read -s -p "SUDO password: " password

export ANSIBLE_BECOME_PASSWORD=$password

echo ">>> Setting up my awesome environment"

ansible-playbook ssh-setup-playbook.yml --ask-vault-pass

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook awesome-setup.yml
#--ask-become-pass
