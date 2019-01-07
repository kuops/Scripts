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
	
	# xterm color
	export TERM="xterm-256color"
	
	# alias 
	alias  gohome='cd /mnt/c/Code/go_workspace'
	alias  vhome='cd /mnt/d/vagrant-home'
	alias  vps='sshpass -p 'xxx' ssh -p 22 root@x.x.x.x -o StrictHostKeyChecking=no'
	alias  google-chrome='google-chrome --no-gpu --no-sandbox --disable-setuid-sandbox'
	alias vim='nvim'
	
	# default editor
	export EDITOR="nvim"

EOF

# set zshrc

  sudo tee -a  ~/.zshrc <<-'EOF'
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
	
	# xterm color
	export TERM="xterm-256color"
	
	# alias 
	alias  gohome='cd /mnt/c/Code/go_workspace'
	alias  vhome='cd /mnt/d/vagrant-home'
	alias  vps='sshpass -p 'xxx' ssh -p 22 root@x.x.x.x -o StrictHostKeyChecking=no'
	alias  google-chrome='google-chrome --no-gpu --no-sandbox --disable-setuid-sandbox'
	alias vim='nvim'

	# default editor
	export EDITOR="nvim"

EOF

# install golang
HTTPS_PROXY=127.0.0.1:1080
HTTP_PROXY=$HTTPS_PROXY
curl -fSLO https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
tar xf go1.11.4.linux-amd64.tar.gz -C /usr/local/
rm go1.11.4.linux-amd64.tar.gz

# install vagrant
wget https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_x86_64.deb
sudo dpkg -i vagrant_2.2.2_x86_64.deb
sudo rm vagrant_2.2.2_x86_64.deb
vagrant plugin install vagrant-hostmanager vagrant-env --plugin-clean-sources --plugin-source https://gems.ruby-china.com/
unset HTTPS_PROXY
unset HTTP_PROXY

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
# sudo apt-get install -y libgtk2.0-0 libxss1 libasound2
# cd ~
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt-get update
# sudo apt-get install -y code

# install vscode insiders
#sudo apt install code-insiders

# install tmux
sudo apt-get install -y tmux

# upgrade soft
sudo apt-get upgrade -y

# insall chinese pinyin
sudo apt-get install fcitx -y
sudo apt-get install fcitx-pinyin -y

# setting ssh config
mkdir -p /home/kuops/.ssh
cat <<EOF> /home/kuops/.ssh/config
# github account
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa
  ProxyCommand nc -x 127.0.0.1:1080 %h %p
EOF
chmod 600 /home/kuops/.ssh/config

# install neovim
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
sudo apt-get install python-dev python-pip python3-dev python3-pip
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh|bash

# neovim setting
# github address: https://github.com/Shougo/dein.vim
# https://github.com/vim-airline/vim-airline-themes

# install subl
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

# install powerline font
sudo apt-get install fonts-powerline

# install oh my zsh
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# use powershell install powerline font
# git clone https://github.com/powerline/fonts.git
# .\install.ps1

# setting zsh theme
# git clone https://github.com/bhilburn/powerlevel9k.git /home/kuops/.oh-my-zsh/custom/themes/powerlevel9k
# sed -i 's@^ZSH_THEME=.*@ZSH_THEME="powerlevel9k/powerlevel9k"@g' /home/kuops/.zshrc
curl https://raw.githubusercontent.com/caiogondim/bullet-train.zsh/master/bullet-train.zsh-theme > $ZSH_CUSTOM/themes/bullet-train.zsh-theme
sed -i 's@^ZSH_THEME=.*@ZSH_THEME="bullet-train"@g' /home/kuops/.zshrc

# install done
echo "done" > /etc/default/init-bash
fi
