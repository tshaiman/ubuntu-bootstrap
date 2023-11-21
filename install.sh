#!/bin/bash

# 1. Update package manager and install dependencies
sudo apt update && sudo apt upgrade -y 
sudo apt install -y  jq snapd zsh python-is-python3 wget ca-certificates gnupg lsb-release curl git unzip build-essential

# 2. install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# 2. Install oh-my-zsh
export RUNZSH=no
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

##############################################################
################            ZSH Config        ################
###############################################################
echo "ZSH CONFIG"
# install powerlevel10k
sh -c "$(git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k)"
# Syntax Plugin
sh -c "$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting)"
# Autocomplete
sh -c "$(git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions)"

##############################################################
################            Cloud Native      ################
###############################################################
## Install Kubectl
export KUBELOGIN_VERSION="v0.0.33"
export STERN_VERSION="1.27.0"
export ENVSUBST_VERSION="v1.4.2"

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install brew 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#install yq 
sudo snap install yq

#Install Helm https://helm.sh/docs/intro/install/#from-script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh

#Install Azure/Kubelogin
wget https://github.com/Azure/kubelogin/releases/download/${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip \
        && unzip kubelogin-linux-amd64.zip \
        && sudo mv bin/linux_amd64/kubelogin /usr/local/bin/kubelogin

#install Stern
wget https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz \
    && sudo tar -xf stern_${STERN_VERSION}_linux_amd64.tar.gz -C /usr/local/bin/

#install envsubst
curl -L https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-`uname -s`-`uname -m` -o envsubst \
        && chmod +x envsubst \
        && sudo mv envsubst /usr/local/bin

# Auto Suggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

## ZSH Customizations
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh

az login
az account set --subscription VideoIndexer-Dev

echo "====sanity checks==="
which kubectl
which stern
which helm
which jq
which yq
which python
which brew
which kubelogin
