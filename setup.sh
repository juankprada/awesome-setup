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

install_dependencies_macos() {
    if ! command -v brew >/dev/null 2>&1; then
	echo "Hombre is not installed. Installing Homebrew first..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install gum
}


# Function to install Ruby on Ubuntu using apt-get
install_dependencies_ubuntu() {
    sudo apt update > /dev/null
    sudo apt install -y gum >/dev/null
    sudo apt install -y software-properties-common >/dev/null
    sudo add-apt-repository --yes --update ppa:ansible/ansible >/dev/null 
    sudo apt install ansible -y >/dev/null
}

install_dependencies_debian() {
    sudo apt install curl > /dev/null
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update > /dev/null
    sudo apt install -y gum >/dev/null
    sudo apt install -y software-properties-common >/dev/null
    sudo apt install ansible -y >/dev/null
}

install_dependencies_fedora() {
    echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo >/dev/null 2>&1
    sudo rpm --import https://repo.charm.sh/yum/gpg.key
    
    sudo dnf install -y gum >/dev/null

    sudo dnf install -y ansible python3-psutil >/dev/null
}


detect_linux_de() {
    export RUNNING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    export RUNNING_KDE=$([[ "$XDG_CURRENT_DESKTOP" == *"KDE"* ]] && echo true || echo false)
}
		 

OS=$(uname)
if [ "$OS" = "Darwin" ]; then
    OS="Mac"
    install_dependencies_macos
elif [ "$OS" = "Linux" ]; then
    detect_linux_de
    if [ -f /etc/os-release ]; then
	. /etc/os-release
	case "$ID" in
	    ubuntu)
		OS="Ubuntu"
		install_dependencies_ubuntu
	    ;;
	    fedora)
		OS="Fedora"
		install_dependencies_fedora
	    ;;
	    debian)
	    OS="Debian"
	    install_dependencies_debian
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

gum input --password --value "$password"
#read -s -p "SUDO password: " password

export ANSIBLE_BECOME_PASSWORD=$password

echo ">>> Setting up my awesome environment"

ansible-playbook ssh-setup-playbook.yml --ask-vault-pass

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519

ansible-playbook awesome-setup.yml
#--ask-become-pass
