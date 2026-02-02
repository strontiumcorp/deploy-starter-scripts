#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
chmod +x "${SCRIPT_DIR}/../shared.sh"
source "${SCRIPT_DIR}/../shared.sh"

# Check if apt is installed or the system is debian based
if ! command -v apt-get &> /dev/null
then
    perror "This script is only for Debian based systems."
    exit 1
fi

if ! grep -qiE 'debian|ubuntu' /etc/os-release; then
    perror "This script is only for Debian based systems."
    exit 1
fi

# Ask for sudo password once at the start
sudo -v

export DEBIAN_FRONTEND=noninteractive

pinfo "Removing any existing installation of Docker..."
old_pkgs=$(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc 2>/dev/null | cut -f1 || true)
if [ -n "$old_pkgs" ]; then
    sudo apt-get remove -y $old_pkgs
fi


pinfo "Adding Docker repository..."
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
. /etc/os-release
repo_os="ubuntu"
if [ "${ID:-}" = "debian" ]; then
    repo_os="debian"
fi
sudo curl -fsSL "https://download.docker.com/linux/${repo_os}/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/${repo_os}
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update -y

pinfo "Installing Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


pinfo "Adding user to docker group..."
sudo usermod -aG docker $USER

pinfo "Restarting Docker service..."
sudo systemctl restart docker
sudo systemctl enable docker

psuccess "Docker is installed and ready to use. Please login again to use docker commands without sudo."



