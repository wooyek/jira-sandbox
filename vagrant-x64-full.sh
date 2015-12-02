#!/bin/bash
# ======================================
# System update and common utilities
# ======================================

cat /vagrant/.ssh_key >> .ssh/authorized_keys

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y htop git unzip
sudo apt-get install -y nginx apache2-utils 
# sudo apt-get install -y python python-dev python-pip python-virtualenv supervisor
# sudo apt-get install -y libxml2-dev libxslt1-dev build-essential

# Change Time Zone
# dpkg-reconfigure tzdata
sudo timedatectl set-timezone Europe/Warsaw


# ======================================
# PostgreSQL
# ======================================

# https://confluence.atlassian.com/jira/connecting-jira-to-postgresql-185729433.html#ConnectingJIRAtoPostgreSQL-1.CreateandconfigurethePostgreSQLdatabase
#sudo apt-get install -y postgresql postgresql-contrib libpq-dev
#sudo -u postgres createuser jiradbuser --no-createdb --no-superuser --no-createrole
#sudo -u postgres psql -c "ALTER USER jiradbuser WITH PASSWORD 'outside produce feature supply"
#sudo -u postgres psql -c "CREATE DATABASE jiradb WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;"
#sudo -u postgres psql -c "ALTER USER jiradbuser WITH SUPERUSER"
# The above is un secure but i'm not a DBA and for now it must do

# For interactive managment use
# sudo -i -u postgres


# ======================================
# Oracle Java 8
# ======================================

sudo apt-add-repository -y ppa:webupd8team/java
sudo apt-get update

# This will prepare for silent install
# http://askubuntu.com/a/190674
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y oracle-java8-set-default
echo JAVA_HOME=/usr/lib/jvm/java-8-oracle/ | sudo tee --append /etc/environment


# ======================================
# Copy files so the installer wont complain about symlinks 
# not working in /vagrant/ folder when windows a host system
cp -r /vagrant/* ./


# ======================================
# Jira
# ======================================

sudo ./downloads/atlassian-jira-software-7.0.0-jira-7.0.0-x64.bin -q -varfile ../atlassian-jira.varfile
sudo cp ./downloads/postgresql-9.4-1204.jdbc42.jar /opt/atlassian/jira/lib/

# ======================================
# Confluence
# ======================================

sudo ./downloads/atlassian-confluence-5.8.14-x64.bin -q -varfile ../atlassian-confluence.varfile
sudo chown confluence /var/atlassian/application-data/confluence/


# ======================================
# Bitbucket
# ======================================

sudo ./downloads/atlassian-bitbucket-4.0.2-x64.bin -q -varfile ../atlassian-bitbucket.varfile
sudo chown atlbitbucket /var/atlassian/application-data/bitbucket/


# ======================================
# Bamboo
# ======================================

#sudo useradd -r -s /bin/false atlassian -c "Service account for Atlassian products"
sudo useradd -s /bin/false atlassian -c "Service account for Atlassian products"
sudo mkdir /opt/atlassian/bamboo/
sudo tar -xzvf ./downloads/atlassian-bamboo-5.9.4.tar.gz --directory /opt/atlassian/bamboo/ --strip-components=1

# This is stupid, but for now must do
# https://confluence.atlassian.com/bamboo/running-bamboo-as-a-linux-service-416056046.html	
sudo chown atlassian /opt/atlassian/bamboo
# sudo chown bamboo /opt/atlassian/bamboo/logs/

sudo mkdir /var/atlassian/application-data/bamboo/
sudo chown atlassian /var/atlassian/application-data/bamboo/
sudo echo bamboo.home=/var/atlassian/application-data/bamboo/ | sudo tee --append /opt/atlassian/bamboo/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

# Service script for bamboo
# https://confluence.atlassian.com/bamboo/running-bamboo-as-a-linux-service-416056046.html
sudo cp bamboo /etc/init.d/
sudo chmod +x /etc/init.d/bamboo
sudo update-rc.d bamboo defaults
sudo /etc/init.d/bamboo start

# ======================================
# Crowd
# ======================================

INSTALL_BASE="/opt/atlassian/crowd"
CROWD_HOME="/var/atlassian/application-data/crowd"
sudo mkdir ${INSTALL_BASE}
sudo chown -R atlassian /opt/atlassian/crowd
sudo tar -xzvf ./downloads/atlassian-crowd-2.8.3.tar.gz --directory /opt/atlassian/crowd/ --strip-components=1
sudo echo crowd.home=/var/atlassian/application-data/crowd/ | sudo tee --append /opt/atlassian/crowd/crowd-webapp/WEB-INF/classes/crowd-init.properties

# https://confluence.atlassian.com/display/CROWD/Setting+Crowd+to+Run+Automatically+and+Use+an+Unprivileged+System+User+on+UNIX
sudo useradd -s /bin/false crowd -c "Service account for Atlassian Crowd products"
CROWD_USER="crowd"
CROWD_GROUP="crowd"
sudo chgrp ${CROWD_GROUP} ${INSTALL_BASE}/{*.sh,apache-tomcat/bin/*.sh}
sudo chmod g+x ${INSTALL_BASE}/{*.sh,apache-tomcat/bin/*.sh}
sudo chown -R ${CROWD_USER} ${CROWD_HOME} ${INSTALL_BASE}/apache-tomcat/{logs,work,temp}
sudo touch -a ${INSTALL_BASE}/atlassian-crowd-openid-server.log
sudo mkdir ${INSTALL_BASE}/database
sudo chown -R ${CROWD_USER} ${INSTALL_BASE}/{database,atlassian-crowd-openid-server.log}



# Service script for bamboo
# https://confluence.atlassian.com/bamboo/running-bamboo-as-a-linux-service-416056046.html
sudo cp crowd /etc/init.d/
sudo chmod +x /etc/init.d/crowd
sudo update-rc.d crowd defaults
sudo /etc/init.d/crowd start


# ======================================
# Nginx reverse proxy
# ======================================

sudo ln -s /home/vagrant/atlassian.conf /etc/nginx/sites-available/atlassian.conf
sudo ln -s /etc/nginx/sites-available/atlassian.conf /etc/nginx/sites-enabled/atlassian.conf
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload
sudo cat /vagrant/hosts.txt | sudo tee --append /etc/hosts

# ======================================
# Postfix
# ======================================

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-14-04
# This will popup a console setup wizard
#sudo apt-get -y install postfix mailutils
#echo 'inet_interfaces = loopback-only' | sudo tee --append /etc/postfix/main.cf
#sudo service postfix restart

