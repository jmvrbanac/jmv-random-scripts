#!/bin/bash
# HERE BE DRAGONS....
# This file is not designed to be executed. It is a collection of commands to
# execute depending on the use-case.

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update

# Themes
sudo apt-get install -y arc-theme

# Editors
sudo apt-get install -y xsel neovim

sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

# Install Git things
sudo apt-get install -y git git-cola gitg

# General Utils
sudo apt-get install -y gdebi gparted pavucontrol alacarte silversearcher-ag \
    wget curl keepassx apt-transport-https ca-certificates shutter redshift-gtk \
    apt-file network-manager-openconnect-gnome

# Gtk Development
sudo apt-get install -y glade python-gi

# Random Applications
sudo apt-get install -y pithos corebird hexchat

# U2F
sudo wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -O /etc/udev/rules.d/70-u2f.rules

# Docker
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository  "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
sudo apt-get update
sudo apt-get -y install docker-engine docker-compose

# Setup Dev Repos
mkdir -p ~/Repositories/github.com
mkdir -p ~/Repositories/github.com/jmvrbanac

git clone git@github.com:jmvrbanac/dotfiles.git ~/Repositories/github/jmvrbanac/dotfiles
git clone git@github.com:jmvrbanac/jmv-random-scripts.git ~/Repositories/github/jmvrbanac/jmv-random-scripts

ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.bashrc_extra ~/.bashrc_extra
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.fonts.conf ~/.fonts.config

# Install Rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

# Cuckoo Build Deps
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# Install Python Dev
sudo apt-get install -y build-essential python-dev libffi-dev libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
    python-pip python3-pip libpq-dev

git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

pyenv install 2.7.12
pyenv install 3.5.3
pyenv install 3.6.0
pyenv install pypy2-5.6.0
pyenv install pypy3.5-c-jit-latest
pyenv global 2.7.12 3.5.3 3.6.0 pypy2-5.6.0

pip install -U pip

git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
echo 'pyenv virtualenvwrapper' >> ~/.bashrc
source ~/.bashrc

# Setup local bin
mkdir -p ~/.local/bin
echo 'export PATH="~/.local/bin/:$PATH"' >> ~/.bashrc

# Install pipsi
mkvirtualenv pipsi
pip install pipsi

pipsi install tox
pipsi install magic-wormhole
