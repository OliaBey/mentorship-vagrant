# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "myjenkins" do |cen|
     cen.vm.box = "geerlingguy/centos7"
     cen.vm.box_version = "1.2.16"
     cen.vm.network "private_network", ip: "192.168.50.4"
     cen.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true
     cen.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true  
     cen.vm.synced_folder "file/jenkins/", "/home/vagrant/"
     cen.vm.provision "shell" do |s| 
       s.path = "./provision/jenkins-setup.sh"
       s.args = ["java-1.8.0-openjdk-devel"]
     end
     cen.vm.provider "virtualbox" do |vb|
       vb.name = "jenkins"
       vb.memory = "4096"
     end
   end

  config.vm.define "mytomcat" do |tom|
     tom.vm.box = "geerlingguy/centos7"
     tom.vm.box_version = "1.2.16"
     tom.vm.network "private_network", ip: "192.168.50.3"
     tom.vm.network "forwarded_port", guest: 8080, host: 4000, auto_correct: true
     tom.vm.network "forwarded_port", guest: 80, host: 4567
     #tom.vm.synced_folder "file/tomcat/", "/home/vagrant/"
     tom.vm.synced_folder "roles/", "/home/vagrant/roles"
     tom.vm.provision "shell", inline: "sudo yum -y install ansible"
     #tom.vm.provision "shell" do |s| 
     #  s.path = "./provision/tomcat-setup.sh"
     #  s.args = ["java-1.8.0-openjdk", "tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz", "apache-tomcat-9*tar.gz"]
     tom.vm.provision "ansible_local" do |ansible|
        ansible.become = true
        ansible.playbook = "playbook.yml"
        #ansible.galaxy_role_file = "requirements.yml"
        #ansible.galaxy_roles_path = "/home/vagrant/roles"
        #ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
        end
     tom.vm.provider "virtualbox" do |vb|
       vb.name = "mytomcat"
     end
   end

  config.vm.define "myzabbix" do |zab|
     zab.vm.box = "geerlingguy/centos7"
     zab.vm.box_version = "1.2.16"
     zab.vm.box_check_update = false
     zab.vm.network "public_network"
     zab.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true 
     zab.vm.synced_folder "file/zabbix/", "/home/vagrant/"
     zab.vm.provision "shell", path: "./provision/zabbix-setup.sh"
     zab.vm.provider "virtualbox" do |vb|
       vb.name = "zabbix"
       vb.memory = "1024"
     end
   end

  config.vm.define "true" do |zab|
     zab.vm.box = "geerlingguy/centos7"
     zab.vm.box_version = "1.2.16"
     zab.vm.box_check_update = false
     zab.vm.network "public_network"
     zab.vm.network "forwarded_port", guest: 5000, host: 5000, auto_correct: true 
     zab.vm.network "forwarded_port", guest: 5001, host: 5001, auto_correct: true
     zab.vm.synced_folder "file/zabbix/", "/home/vagrant/"
     zab.vm.provision "shell", path: "./provision/zabbix-setup.sh"
     zab.vm.provider "virtualbox" do |vb|
       vb.name = "true"
       vb.memory = "1024"
     end
   end

end
