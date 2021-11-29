# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

# config.vm.box = "gbailey/amzn2"

  config.vm.define "web", primary: true do |web|
    web.vm.box = "gbailey/amzn2"
    web.vm.network "private_network", ip: "192.168.56.11"
    web.vm.hostname = "web.local"

    web.vm.provision "shell", inline: $script_etc_hosts
    web.vm.provision "shell", inline: "/bin/cp /vagrant/config/* /tmp/"
  end

  config.vm.define "srv" do |srv|
    srv.vm.box = "ubuntu/focal64"
    srv.vm.network "private_network", ip: "192.168.56.12"
    srv.vm.hostname = "srv.local"

    srv.vm.provision "shell", inline: $script_etc_hosts
    srv.vm.provision "shell", inline: "/bin/cp /vagrant/config/* /tmp/"
  end

  config.vm.define "db1" do |db1|
    db1.vm.box = "gbailey/amzn2"
    db1.vm.network "private_network", ip: "192.168.56.101"
    db1.vm.hostname = "db.local"

    db1.vm.provision "shell", inline: $script_etc_hosts
  end


end


$script_etc_hosts = <<-SCRIPT
sudo cat > /etc/hosts <<CAT
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost6 localhost6.localdomain6

192.168.56.11  web.local web
192.168.56.12  srv.local srv
192.168.56.101 db1.local db1

CAT

SCRIPT

