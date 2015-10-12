# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "jira-sandbox"

    config.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 4
    end

    config.vm.define "full" do |guest|
        guest.vm.provision "shell", path: "vagrant-x64-full.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 8192
            v.cpus = 4
        end
    end

    config.vm.define "testing" do |guest|
        guest.vm.provision "shell", path: "vagrant-x64-testing.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 4
        end
    end

    # Nginx
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8000, guest: 80

    # Jira
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080

    # Bamboo
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8085, guest: 8085

    # Confluence
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8090, guest: 8090

    # Bitbucket
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 7990, guest: 7990
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8006, guest: 8006

    # PostgreSQL
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 5432, guest: 5432

end
