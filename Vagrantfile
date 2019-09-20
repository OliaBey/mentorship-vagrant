# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "jenkins" do |cen|
     cen.vm.box = "centos/7"
     cen.vm.box_check_update = false
     cen.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true 
     cen.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     #cen.vm.synced_folder "./data", "/vagrant_data"
     cen.vm.provision "shell", path: "./provision/jenkins-setup.sh"
     cen.vm.provider "virtualbox" do |vb|
       vb.name = "jenkins"
       vb.memory = "4096"
     end
   end

  config.vm.define "zabbix" do |zab|
     zab.vm.box = "centos/7"
     zab.vm.box_check_update = false
     zab.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true 
     zab.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     #zab.vm.synced_folder "./data", "/vagrant_data"
     #zab.vm.provision "shell", path: "./provision/zabbix-setup.sh"
     zab.vm.provider "virtualbox" do |vb|
       vb.name = "zabbix"
       vb.memory = "1024"
     end
   end

#https://github.com/kploesser/vagrant-for-tomcat
  config.vm.define "tomcat" do |tom|
     tom.vm.box = "centos/7"
     #tom.vm.box = "geerlingguy/centos7"
     #tom.vm.box_version = "1.2.16"
     #tom.vm.box_check_update = false
     tom.vm.network "forwarded_port", guest: 8080, host: 4000, auto_correct: true
     tom.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     tom.vm.synced_folder "webapps/", "/home/vagrant/webapps"
     tom.vm.provision "shell", path: "./provision/tomcat-setup.sh"
     tom.vm.provider "virtualbox" do |vb|
       vb.name = "tomcat"
     end
   end
end
