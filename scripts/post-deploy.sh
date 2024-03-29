#!/bin/bash
# centos 7.6
value=$( grep -ic "entry" /etc/hosts )
if [ $value -eq 0 ]
then
echo "
################ cassandra-cookbook host entry ############
192.168.57.202  BGPAPLX01
192.168.57.203  BGPAPLX02
192.168.57.204  BGPAPLX03
######################################################
" > /etc/hosts
fi
sudo  yum install epel-release -y
sudo  yum install -y java-1.8.0-openjdk  java-1.8.0-openjdk-devel 
sudo ln -s  /usr/lib/jvm/java-1.8.0-openjdk  /usr/lib/jvm/jdk

sudo sh -c 'echo export JAVA_HOME=/usr/lib/jvm/jdk/ >> /home/hduser/.bashrc'

# Add hadoop user
sudo groupadd hadoop
sudo useradd -g hadoop hduser
echo hduser:hduser | sudo chpasswd
sudo adduser hduser sudo

sudo -u hduser ssh-keygen -t rsa -P '' -f /home/hduser/.ssh/id_rsa
sudo sh -c  "cat /home/hduser/.ssh/id_rsa.pub >> /home/hduser/.ssh/authorized_keys"
# Prevent ssh setup questions
sudo sh -c  "printf 'NoHostAuthenticationForLocalhost yes
 Host *  
    StrictHostKeyChecking no' > /home/hduser/.ssh/config"

# Download Cassandra to the vagrant shared directory if it doesn't exist yet
cd /vagrant
if [ ! -f apache-cassandra-3.11.4-bin.tar.gz ]; then
	wget http://apache.stu.edu.tw/cassandra/3.11.4/apache-cassandra-3.11.4-bin.tar.gz 
fi
# Unpack Cassandra and install
sudo tar vxzf apache-cassandra-3.11.4-bin.tar.gz -C /usr/local
cd /usr/local
sudo mv apache-cassandra-3.11.4 apache-cassandra
sudo chown -R hduser:hadoop apache-cassandra

# Cassandra variables
sudo sh -c 'echo export CASSANDRA_HOME=/usr/local/apache-cassandra >> /home/hduser/.bashrc'
sudo sh -c 'echo export PATH=\$PATH:\$CASSANDRA_HOME/bin >> /home/hduser/.bashrc'

cd /vagrant
sudo cp machine_*.yaml /usr/local/apache-cassandra/conf/
sudo chown -R hduser:hadoop  /usr/local/apache-cassandra/conf/ 
sudo mv /usr/local/apache-cassandra/conf/machine_1.yaml  /usr/local/apache-cassandra/conf/cassandra.yaml
