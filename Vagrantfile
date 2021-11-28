# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

# config.vm.box = "gbailey/amzn2"

  config.vm.define "web", primary: true do |web|
    web.vm.box = "gbailey/amzn2"
    web.vm.network "private_network", ip: "192.168.56.11"
    web.vm.hostname = "web.local"
  end

  config.vm.define "srv" do |srv|
    srv.vm.box = "ubuntu/focal64"
    srv.vm.network "private_network", ip: "192.168.56.12"
    srv.vm.hostname = "srv.local"
  end

  config.vm.define "db1" do |db1|
    db1.vm.box = "gbailey/amzn2"
    db1.vm.network "private_network", ip: "192.168.56.101"
    db1.vm.hostname = "db.local"
  end


end

