#!/bin/bash
set -ex

# change dir to home
cd ~

# set bashrc
if ! [ -f /etc/default/init-bash ];then
  sudo tee -a  ~/.bashrc <<-'EOF'
	# umask settings
	umask  0022

	# Vagrant variables
	export PATH="$PATH:/mnt/d/VirtualBox"
	export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
	export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH=/mnt/d/
	export VAGRANT_HOME=/mnt/d/vagrant-home/.vagrant.d/
	
	# golang variables
	export GOROOT=/usr/local/go
	export GOPATH=/mnt/c/Code/go_workspace
	export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
	
	# X Server variables
	export LIBGL_ALWAYS_INDIRECT=1
	export DISPLAY=0:0

	# fcitx variables
	export XMODIFIERS=@im=fcitx
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	
	# alias 
	alias  gohome='cd /mnt/c/Code/go_workspace'
	alias  vhome='cd /mnt/d/vagrant-home'
	alias  vps='sshpass -p 'xxx' ssh -p 22 root@x.x.x.x -o StrictHostKeyChecking=no'
	alias  google-chrome='google-chrome --no-gpu --no-sandbox --disable-setuid-sandbox'
EOF

# install golang
curl -fSLO https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar xf go1.11.4.linux-amd64.tar.gz -C /usr/local/
rm go1.11.4.linux-amd64.tar.gz

# install vagrant
wget https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
sudo dpkg -i vagrant_2.2.2_x86_64.deb
sudo rm vagrant_2.2.2_x86_64.deb
vagrant plugin install vagrant-hostmanager vagrant-env --plugin-clean-sources --plugin-source https://gems.ruby-china.com/

# settings china apt-get sources
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
sudo apt-get update

# install software
sudo apt-get install -y ansible sshpass python-pip git bash-completion

# setting git global configs
git config --global user.name "kuops"
git config --global user.email opshsy@gmail.com
git config --global core.editor vim
git config --global color.ui true

# set no password sudoers
sudo sh -c ' echo "kuops    ALL=(ALL)    NOPASSWD: ALL" > /etc/sudoers.d/kuops'

# install xfce4
sudo apt-get install -y xfce4

# install vscode
sudo apt-get install -y libgtk2.0-0 libxss1 libasound2
cd ~
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code

# install vscode insiders
#sudo apt install code-insiders

# install tmux
sudo apt-get install -y tmux

# upgrade soft
sudo apt-get upgrade

# insall chinese pinyin
sudo apt-get install fcitx
sudo apt-get install fcitx-pinyin

# setting ssh config
mkdir -p /home/kuops/.ssh
cat <<EOF> /home/kuops/.ssh/config
# github account
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa
  ProxyCommand nc -x 10.0.7.1:1080 %h %p
EOF
chmod 600 /home/kuops/.ssh/config

# install neovim
sudo apt-get install software-properties-common
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
fi
