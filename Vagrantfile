# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"

    # Example proxy settings
    # config.proxy.http     = "http://10.56.3.1:8080"
    # config.proxy.https    = "http://10.56.3.1:8080"
    # config.proxy.no_proxy = "localhost,127.0.0.1"

    config.vm.provider "virtualbox" do |v|
        v.memory = 8192
        v.cpus = 4
    end

    config.vm.define "full" do |guest|
        guest.vm.hostname = "jira.example.com"
        guest.vm.network "private_network", ip: "10.0.0.1"
        guest.vm.provision "shell", path: "vagrant-x64-full.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 8192
            v.cpus = 4
        end

        # Nginx
        guest.vm.network "forwarded_port", host: 80, guest: 80

        # Jira
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080

        # Confluence
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8090, guest: 8090

        # Bamboo
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8085, guest: 8085

        # Bitbucket
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 7990, guest: 7990
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8006, guest: 8006

        # Crowd
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8095, guest: 8095

        # PostgreSQL
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 5432, guest: 5432
    end

    config.vm.define "jsd" do |guest|
        guest.vm.hostname = "jsd.example.com"
        guest.vm.network "private_network", ip: "10.0.0.2"
        guest.vm.provision "shell", path: "vagrant-x64-basic.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
        end
        # No port forwarding to enable JIRA Service Desk setup on separate VM
        # map 10.0.0.2 to jsd.example.com URL through hosts file
    end


    config.vm.define "testing" do |guest|
        guest.vm.hostname = "jira.example.com"
        guest.vm.network "private_network", ip: "10.0.0.1"
        guest.vm.provision "shell", path: "vagrant-x64-testing.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 4
        end

        # Jira
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080

        # Confluence
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8090, guest: 8090
    end

    config.vm.define "jira6" do |guest|
        guest.vm.hostname = "jira.example.com"
        guest.vm.network "private_network", ip: "10.0.0.1"
        guest.vm.provision "shell", path: "vagrant-x64-jira6.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 4
        end

        # Nginx
        guest.vm.network "forwarded_port", host: 80, guest: 80

        # Jira
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080

        # Confluence
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8090, guest: 8090
    end

    config.vm.define "basic" do |guest|
        guest.vm.hostname = "jira.example.com"
        guest.vm.network "private_network", ip: "10.0.0.1"
        guest.vm.provision "shell", path: "vagrant-x64-basic.sh"
        guest.vm.provider "virtualbox" do |v|
            v.memory = 2048
            v.cpus = 2
        end

        # Nginx
        guest.vm.network "forwarded_port", host: 80, guest: 80

        # Jira
        guest.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080
    end

end
