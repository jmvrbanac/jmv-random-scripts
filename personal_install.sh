#!/bin/bash

# Editors
sudo apt-get install -y vim vim-gnome

# Install Git things
sudo apt-get install -y git git-cola gitg

# General Utils
sudo apt-get install -y gdebi gparted pavucontrol alacarte silversearcher-ag wget curl keepassx apt-transport-https ca-certificates

# U2F support
sudo wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules -O /etc/udev/rules.d/70-u2f.rules

# Set Key Repeats
echo "xset r rate 200 60" >> ~/.xinitrc

# Vim plugin hookups
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
mkdir ~/.vim-tmp

# Internet Apps
sudo apt-get install -y hexchat pithos

# Installing Docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c "echo 'deb https://apt.dockerproject.org/repo debian-stretch main' > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y docker-engine

# Python Dev
sudo apt-get install -y build-essential python-dev libffi-dev libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev

# - Installing PyEnv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc

# - Install Python Versions
pyenv install 2.7.12
pyenv install 3.4.5
pyenv install 3.5.2
pyenv install pypy-5.3.1
pyenv global 2.7.12 3.5.2 3.4.5 pypy-5.3.1

# - Install virtualenvwrapper
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
echo 'pyenv virtualenvwrapper' >> ~/.bashrc
source ~/.bashrc

# Setup local bin
echo 'export PATH="~/.local/bin/:$PATH"' >> ~/.bashrc

# Setup folders
mkdir -p ~/Repositories/github
mkdir -p ~/Repositories/gitlab

# Setup dotfiles
git clone git@github.com:jmvrbanac/dotfiles.git ~/Repositories/github/dotfiles
ln -s ~/Repositories/github/dotfiles/.vimrc ~/.vimrc
ln -s ~/Repositories/github/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/Repositories/github/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/Repositories/github/dotfiles/.fonts.conf ~/.fonts.config
