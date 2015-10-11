#!/bin/bash
# System update and common utillities

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

# sudo apt-get install -y postgresql postgresql-contrib libpq-dev
# sudo -u postgres createuser jira_user --no-createdb --no-superuser --no-createrole
# sudo -u postgres createdb jira_db
# sudo -u postgres psql -c "ALTER USER jira_user WITH PASSWORD 'with#conversation@edge^shade'"

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
cp /vagrant/* ./


# ======================================
# Jira
# ======================================

sudo ./atlassian-jira-software-7.0.0-jira-7.0.0-x64.bin -q -varfile atlassian-jira.varfile


# ======================================
# Bitbucket
# ======================================

sudo ./atlassian-bitbucket-4.0.2-x64.bin -q -varfile atlassian-bitbucket.varfile

# ======================================
# Confluence
# ======================================

sudo ./atlassian-confluence-5.8.13-x64.bin -q -varfile atlassian-confluence.varfile


# ======================================
# Bamboo
# ======================================

#sudo useradd -r -s /bin/false atlassian -c "Service account for Atlassian products"
sudo useradd -s /bin/false atlassian -c "Service account for Atlassian products"
sudo mkdir /opt/atlassian/bamboo/
sudo tar -xzvf atlassian-bamboo-5.9.4.tar.gz --directory /opt/atlassian/bamboo/ --strip-components=1

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

# does not work at the moment, use:
# sudo /opt/atlassian/bamboo/bin/start-bamboo.sh

# ======================================
# Nginx reverse proxy
# ======================================

sudo ln -s /home/vagrant/atlassian.conf /etc/nginx/sites-available/atlassian.conf
sudo ln -s /etc/nginx/sites-available/atlassian.conf /etc/nginx/sites-enabled/atlassian.conf
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload

# This is not enough, jira binds to url paths and needs to know its' context path
# https://confluence.atlassian.com/display/JIRAKB/Integrating+JIRA+with+Nginx

sudo sed -i~ 's/\(<Connector port="8080"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/jira/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/jira/g' /opt/atlassian/jira/conf/server.xml
sudo /etc/init.d/jira stop
sudo /etc/init.d/jira start

sudo sed -i~ 's/\(<Connector port="8085"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/bamboo/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/bamboo/g' /opt/atlassian/bamboo/conf/server.xml

sudo sed -i~ 's/\(<Connector port="8090"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/confluence/conf/server.xml
sudo sed -i 's/\(<Context path="\)/\1\/confluence/g' /opt/atlassian/confluence/conf/server.xml
sudo /etc/init.d/confluence stop
sudo /etc/init.d/confluence start

sudo sed -i~ 's/\(<Connector port="7990"\)/\1 proxyName="dev.example.com" proxyPort="80"/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
# sudo sed -i 's/\(<Context [:s:]*path="\)/\1\/bitbucket/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
sudo sed -i 's/\(path="\)/\1\/bitbucket/g' /opt/atlassian/bitbucket/4.0.2/conf/.default-server.xml
sudo /opt/atlassian/bitbucket/4.0.2/bin/stop-bitbucket.sh
sudo /opt/atlassian/bitbucket/4.0.2/bin/start-bitbucket.sh
