# Kubeadm 集群一键启动

vagrant 安装插件

```
vagrant plugin install vagrant-hostmanager --plugin-clean-sources --plugin-source https://gems.ruby-china.com/
```

下载 vbox 文件

```
curl -SLO /mnt/d/localrepo/ http://mirrors.ustc.edu.cn/centos-cloud/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-1809_01.VirtualBox.box
```

vagrant 添加本地文件

```
vagrant box add centos-metadata.json
```

如果使用 windows , path 按以下调整

```
file:///d:/path/to/file.box
```

启动 vagrant

```
vagrant up --provision
```

登录 vm 虚拟机

```
vagrant ssh
```
