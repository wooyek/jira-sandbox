#!/bin/bash
# ======================================
# System update and common utilities
# ======================================

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y htop git unzip
sudo apt-get install -y nginx apache2-utils 
# sudo apt-get install -y python python-dev python-pip python-virtualenv supervisor
# sudo apt-get install -y libxml2-dev libxslt1-dev build-essential

# Change Time Zone
# dpkg-reconfigure tzdata
sudo timedatectl set-timezone Europe/Warsaw
cat /vagrant/.ssh_key >> .ssh/authorized_keys


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
cp -r /vagrant/* ./


# ======================================
# Jira
# ======================================

sudo ./downloads/atlassian-jira-software-7.0.0-jira-7.0.0-x64.bin -q -varfile ../atlassian-jira.varfile

# ======================================
# Nginx reverse proxy
# ======================================

sudo ln -s /home/vagrant/atlassian.conf /etc/nginx/sites-available/atlassian.conf
sudo ln -s /etc/nginx/sites-available/atlassian.conf /etc/nginx/sites-enabled/atlassian.conf
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload
echo '127.0.0.1 dev.example.com jira.example.com bamboo.example.com confluence.example.com bitbucket.example.com' | sudo tee --append /etc/hosts
