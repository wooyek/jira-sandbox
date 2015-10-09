# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "jira-sandbox"
    config.vm.provision "shell", path: "vagrant-setup.sh"
    # config.vm.network "private_network", ip: "10.0.0.1"

    config.vm.provider "virtualbox" do |v|
        v.memory = 6144
        v.cpus = 4
    end

    # Nginx
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 80, guest: 80

    # Jira
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8080, guest: 8080

    # Bamboo
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8085, guest: 8085

    # Bitbucket
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 7990, guest: 7990
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8006, guest: 8006

    # Django development server
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 8000, guest: 8000

    # PostgreSQL
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 5432, guest: 5432

    # Supervisor web manager (custom port)
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 9636, guest: 9636

    # RabbitMQ
    # http://www.rabbitmq.com/management.html
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 15672, guest: 15672
    # http://docs.celeryproject.org/en/latest/getting-started/brokers/rabbitmq.html
    config.vm.network "forwarded_port", host_ip: "127.0.0.1", host: 5672, guest: 5672

end
