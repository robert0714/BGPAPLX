# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end
  config.vm.define "BGPAPLX01" do |d|
    d.vm.box = "bento/centos-7.6"
#   d.vm.box = "robert-hadoop-box"
#   d.vm.box = "ubuntu/xenial64"
    d.vm.hostname = "BGPAPLX01"
#    d.vm.network "private_network", ip: "107.170.38.238"        
    d.vm.network "public_network", bridge: "eno4", ip: "192.168.57.202", auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
    d.vm.provider "virtualbox" do |v|        
      v.memory = 3072
      v.cpus = 1
    end
    d.vm.provision "shell", inline: <<-SHELL
         sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
         sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config   
         systemctl restart sshd
      SHELL
    d.vm.provision :shell, path: "scripts/post-deploy.sh"
#    d.vm.provision :shell, path: "scripts/post-deploy-ubuntu.sh"
    d.vm.provision :shell, inline: " sudo route delete default; sudo route add default gw 192.168.57.1 dev eth1 ",run: "always"
  end  
  config.vm.define "BGPAPLX02" do |d| 
    d.vm.box = "robert-cassandra-box" 
    d.vm.hostname = "BGPAPLX02"
    #d.vm.network "private_network", ip: "107.170.112.81"
    d.vm.network "public_network", bridge: "eno4", ip: "192.168.57.203", auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
    
    d.vm.provider "virtualbox" do |v|        
      v.memory = 3072
      v.cpus = 1
    end
    d.vm.provision "shell", inline: <<-SHELL
         sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
         sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config   
         systemctl restart sshd
         sudo mv /usr/local/apache-cassandra/conf/machine_2.yaml  /usr/local/apache-cassandra/conf/cassandra.yaml
      SHELL
    d.vm.provision :shell, inline: " sudo route delete default; sudo route add default gw 192.168.57.1 dev eth1 ",run: "always"
  end  
  config.vm.define "BGPAPLX03" do |d| 
    d.vm.box = "robert-cassandra-box" 
    d.vm.hostname = "BGPAPLX03"
#    d.vm.network "private_network", ip: "107.170.115.161"
    d.vm.network "public_network", bridge: "eno4", ip: "192.168.57.204", auto_config: "false", netmask: "255.255.255.0" , gateway: "192.168.57.1"
    d.vm.provider "virtualbox" do |v|        
      v.memory = 3072
      v.cpus = 1
    end
    d.vm.provision "shell", inline: <<-SHELL
         sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config    
         sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config   
         systemctl restart sshd
         sudo mv /usr/local/apache-cassandra/conf/machine_3.yaml  /usr/local/apache-cassandra/conf/cassandra.yaml
      SHELL
    d.vm.provision :shell, inline: " sudo route delete default; sudo route add default gw 192.168.57.1 dev eth1 ",run: "always"
  end
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true
    config.vbguest.no_remote = true
  end
end
