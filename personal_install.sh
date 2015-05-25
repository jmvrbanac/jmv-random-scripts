#!/bin/bash

# Add Sources
sudo apt-add-repository ppa:yubico/stable
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"

# sudo apt-get update
sudo apt-get install -y vim vim-gnome

# Install Git things
sudo apt-get install -y git git-cola gitg

# Utilities
sudo apt-get install -y gdebi gparted pavucontrol alacarte silversearcher-ag
sudo apt-get install -y curl

# U2F support
sudo wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -O /etc/udev/rules.d/70-u2f.rules

# Setting up plugin hookups for vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
mkdir ~/.vim-tmp

ln -s ~/Repositories/github/dotfiles/.vimrc ~/.vimrc
ln -s ~/Repositories/github/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Repositories/github/dotfiles/.gitconfig ~/.gitconfig

# Internet Things
sudo apt-get install -y network-manager-vpnc mumble hexchat pidgin pidgin-otr

# Development
sudo apt-get install -y lxc-docker
sudo apt-get install -y python-pip gcc libffi-dev python-dev libssl-dev libsqlite3-dev libxml2-dev libxslt1-dev make build-essential zlib1g-dev libbz2-dev libreadline-dev
sudo apt-get install -y ruby
sudo pip install virtualenvwrapper -U

# Corebird
sudo apt-get install -y sqlite3 libglib2.0-dev libgtk-3-dev librest-dev valac-0.26 libgee-0.8-dev libjson-glib-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev intltool

# Powersaving
sudo apt-get install -y laptop-mode-tools
sudo su -c 'echo "options snd_hda_intel power_save=1" > /etc/modprobe.d/audio_powersave.conf'
sudo su -c 'echo 5 > /proc/sys/vm/laptop_mode'
sudo su -c 'echo "options usbcore autosuspend=1" > /etc/modprobe.d/usbcore'
# sudo su -c 'echo "blacklist uhci_hcd" >> /etc/modprobe.d/blacklist'

# - PyENV
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'pyenv virtualenvwrapper' >> ~/.bashrc
source ~/.bashrc
