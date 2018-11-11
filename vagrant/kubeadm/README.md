# ubuntu-vagrant

vagrant 安装插件

```
vagrant plugin install vagrant-hostmanager --plugin-clean-sources --plugin-source https://gems.ruby-china.com/
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
