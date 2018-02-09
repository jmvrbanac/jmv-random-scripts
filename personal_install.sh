#!/bin/bash

# Add i386 multi-arch support
# sudo dpkg --add-architecture i386

sudo apt-get update

# Editors
sudo apt-get install -y neovim

# Install Git things
sudo apt-get install -y git git-cola gitg

# Theming
sudo apt-get install -y arc-theme adwaita-qt numix-icon-theme gnome-tweak-tool
sudo apt-get remove -y gnome-shell-extension-ubuntu-dock
gsettings set org.gnome.shell enable-hot-corners true

# General Utils
sudo apt-get install -y gdebi gparted pavucontrol alacarte silversearcher-ag \
    wget curl apt-transport-https ca-certificates shutter redshift-gtk \
    apt-file network-manager-openconnect-gnome xsel net-tools

# Random
sudo apt-get install -y pithos corebird keepassx hexchat

# Signal
curl -s https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add -
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

# U2F support (if needed)
# sudo wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -O /etc/udev/rules.d/70-u2f.rules

# Set Key Repeats
echo "xset r rate 200 60" >> ~/.xinitrc

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install -y docker-ce docker-compose
# Only use if needed
# sudo usermod -aG docker $USER

# For WebEx
sudo apt-get install -y lib32stdc++6 libxmu6:i386 libgcj17-awt:i386 libpangoxft-1.0-0:i386 \
    libxft2:i386 libpangoft2-1.0-0:i386 libpangox-1.0-0:i386 libxv1:i386

# Laptop Only (Fix touchpad tap-to-click)
sudo apt-get remove -y xserver-xorg-input-synaptics

# Setup Dev Repos
mkdir -p ~/Repositories/github.com
mkdir -p ~/Repositories/github.com/jmvrbanac
mkdir -p ~/.config/nvim

git clone git@github.com:jmvrbanac/dotfiles.git ~/Repositories/github.com/jmvrbanac/dotfiles
git clone git@github.com:jmvrbanac/jmv-random-scripts.git ~/Repositories/github.com/jmvrbanac/jmv-random-scripts

ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/nvim-init.vim ~/.config/nvim/init.vim
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.vimrc ~/.vimrc
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.gitconfig-work ~/.gitconfig-work
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.bashrc_extra ~/.bashrc_extra
ln -s ~/Repositories/github.com/jmvrbanac/dotfiles/.fonts.conf ~/.fonts.config

# Python Dev
sudo apt-get install -y build-essential python-dev libffi-dev libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev \
    python-pip python3-pip libpq-dev

git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

pyenv install 2.7.14
pyenv install 3.4.7
pyenv install 3.5.4
pyenv install 3.6.3
pyenv install pypy2.7-5.9.0
pyenv install pypy3.5-5.9.0
pyenv global 3.6.3 2.7.14 pypy3.5-5.9.0 pypy2.7-5.9.0 3.5.4 3.4.7

git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
echo 'pyenv virtualenvwrapper' >> ~/.bashrc
source ~/.bashrc

# Rust dev
sudo apt-get install -y rustc cargo

# For Postgres dev
sudo apt-get install -y postgresql libpq-dev

# Setup local bin
echo 'export PATH="~/.local/bin/:$PATH"' >> ~/.bashrc

# Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

rbenv install 2.4.2
rbenv global 2.4.2

# Pipsi Setup
pip install pipsi
pipsi install tox
pipsi install twine
pipsi install magic-wormhole
