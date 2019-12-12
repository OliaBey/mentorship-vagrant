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
     cen.vm.provider "virtualbox" do |vb|
       vb.name = "jenkins"
       vb.memory = "1024"
     end
     cen.vm.provision "shell" do |s| 
       s.path = "./provision/jenkins-setup.sh"
       s.args = ["java-1.8.0-openjdk-devel"]
     end
    # cen.vm.provision "ansible_local" do |ansible|
    #    ansible.playbook = "./ansible/jenkins/playbook.yml"
    # end
   end

  config.vm.define "mytomcat" do |tom|
     tom.vm.box = "geerlingguy/centos7"
     tom.vm.box_version = "1.2.16"
     tom.vm.network "private_network", ip: "192.168.50.3"
     tom.vm.network "forwarded_port", guest: 8080, host: 4000, auto_correct: true
     tom.vm.network "forwarded_port", guest: 80, host: 4567
     tom.vm.synced_folder "file/tomcat/", "/home/vagrant/"
     #tom.vm.provision "shell" do |s| 
     #  s.path = "./provision/tomcat-setup.sh"
     #  s.args = ["java-1.8.0-openjdk", "tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz", "apache-tomcat-9*tar.gz"]
     #end
     #tom.vm.synced_folder "./ansible/roles/", "/home/vagrant/roles"
     tom.vm.provision "shell", inline: "sudo yum -y install ansible"
     tom.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "./ansible/tomcat/playbook.yml"
      #  ansible.galaxy_role_file = "./ansible/roles/requirements.yml"
      #  ansible.galaxy_roles_path = "./ansible/roles/"
      #  ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
      end
     tom.vm.provider "virtualbox" do |vb|
       vb.name = "mytomcat"
     end
      tom.trigger.before :destroy, :halt do |trigger|
        trigger.info = "Removing host from zabbix server..."
        trigger.run_remote = {inline: "sudo sed -i \"s/^HostMetadata=linux.autoreg/HostMetadata=linux.autodereg/\" /etc/zabbix/zabbix_agentd.conf && sudo service zabbix-agent restart"}
      end
  end

  config.vm.define "myzabbix" do |zab|
     zab.vm.box = "geerlingguy/centos7"
     zab.vm.box_version = "1.2.16"
     zab.vm.box_check_update = false
     zab.vm.network "private_network", ip: "192.168.50.5"
     zab.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true 
     zab.vm.network "forwarded_port", guest: 10050, host: 8081, auto_correct: true 
     zab.vm.network "forwarded_port", guest: 10051, host: 8082, auto_correct: true 
     zab.vm.synced_folder "file/zabbix/", "/home/vagrant/"
     zab.vm.provision "shell", path: "./provision/zabbix-setup.sh"
     zab.vm.provider "virtualbox" do |vb|
       vb.name = "zabbix"
       vb.memory = "1024"
     end
   end

#https://github.com/kploesser/vagrant-for-tomcat
  config.vm.define "mytomcat" do |tom|
     #tom.vm.box = "centos/7"
     tom.vm.box = "geerlingguy/centos7"
     tom.vm.box_version = "1.2.16"
     #tom.vm.box_check_update = false
     tom.vm.network  "private_network", ip: "192.168.10.2"
     tom.vm.network "forwarded_port", guest: 8080, host: 4000, auto_correct: true
     tom.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     tom.vm.synced_folder "webapps/", "/home/vagrant/webapps"
     tom.vm.provision "shell" do |s| 
       s.path = "./provision/tomcat-setup.sh"
       s.args = ["java-1.8.0-openjdk", "tomcat-9/v9.0.0.M22/bin/apache-tomcat-9.0.0.M22.tar.gz", "apache-tomcat-9*tar.gz"]
     end
     tom.vm.provider "virtualbox" do |vb|
       vb.name = "mytomcat"
     end
   end

  config.vm.define "apache2" do |apa|
     apa.vm.box = "ubuntu/trusty64"
     #apa.vm.box_check_update = false
     apa.vm.network  "private_network", ip: "192.168.10.3"
     apa.vm.network "forwarded_port", guest: 80, host: 4567
     apa.vm.network "forwarded_port", guest: 5000, host: 4568
     apa.vm.network  "forwarded_port", guest: 22, host: 2222, auto_correct: true 
     apa.vm.synced_folder "apache/", "/home/vagrant/"
     apa.vm.provision "shell", path: "./provision/apache-setup.sh"
     apa.vm.provider "virtualbox" do |vb|
       vb.name = "apache"
     end
   end

end
