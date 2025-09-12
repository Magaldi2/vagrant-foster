Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.boot_timeout = 1800

  # Proxy VM
  config.vm.define "proxy" do |proxy|
    proxy.vm.hostname = "proxy"

    # NAT interface já é padrão (não precisa declarar) → internet garantida
    # Forwarded port para acessar do host
    proxy.vm.network "forwarded_port", guest: 80, host: 8080

    # Rede interna para se comunicar com as outras VMs
    proxy.vm.network "private_network", ip: "10.0.0.20", virtualbox__intnet: "lan_app"

    proxy.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
    end
    proxy.vm.provision "shell", path: "scripts/proxy.sh"
  end

  # Flask VM
  config.vm.define "flask" do |flask|
    flask.vm.hostname = "flask"

    # Apenas rede interna
    flask.vm.network "private_network", ip: "10.0.0.30", virtualbox__intnet: "lan_app"

    flask.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end
    flask.vm.provision "shell", path: "scripts/flask.sh"
  end

  # MongoDB VM
  config.vm.define "mongodb" do |mongo|
    mongo.vm.hostname = "mongodb"

    # Apenas rede interna
    mongo.vm.network "private_network", ip: "10.0.0.40", virtualbox__intnet: "lan_app"

    mongo.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end
    mongo.vm.provision "shell", path: "scripts/mongodb.sh"
  end
end
