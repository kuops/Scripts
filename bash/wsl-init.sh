#!/bin/bash
set -ex

# change dir to home
cd ~

# set bashrc
if ! grep 'WSL'  ~/.bashrc  &> /dev/null ;then
  sudo tee -a  ~/.bashrc <<-'EOF'
	# umask settings
	umask  0002

	# wsl env settings
	export PATH="$PATH:/mnt/d/VirtualBox"
	export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
	export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH=/mnt/d/
	export VAGRANT_HOME=/mnt/d/vagrant-home/.vagrant.d/
	export GOROOT=/usr/local/go
	export GOPATH=/mnt/c/Code/go_workspace
	export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
	# X Server
	export LIBGL_ALWAYS_INDIRECT=1
	export DISPLAY=0:0

	# my alias
	alias  gohome='cd /mnt/c/Code/go_workspace'
	alias  vhome='cd /mnt/d/vagrant-home'
	alias  vps='sshpass -p 'xxx' ssh -p 22 root@x.x.x.x -o StrictHostKeyChecking=no'
EOF
fi

# install golang
curl -fSLO https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
tar xf go1.11.1.linux-amd64.tar.gz -C /usr/local/
rm go1.11.1.linux-amd64.tar.gz

# install vagrant
wget https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
sudo dpkg -i vagrant_2.2.2_x86_64.deb
sudo rm vagrant_2.2.2_x86_64.deb
vagrant plugin install vagrant-hostmanager vagrant-env --plugin-clean-sources --plugin-source https://gems.ruby-china.com/

# settings china apt-get sources
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get install -y ansible sshpass

# setting git global configs
git config --global user.name "kuops"
git config --global user.email opshsy@gmail.com
git config --global core.editor vim
git config --global color.ui true

# set no password sudoers
sudo sh -c ' echo "kuops    ALL=(ALL)    NOPASSWD: ALL" > /etc/sudoers.d/kuops'
