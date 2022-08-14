NUM_WORKER_NODES=3
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
      apt-get update -y
      echo "$IP_NW$((IP_START)) master-node" >> /etc/hosts
      echo "$IP_NW$((IP_START+1)) worker-node01" >> /etc/hosts
      echo "$IP_NW$((IP_START+2)) worker-node02" >> /etc/hosts
  SHELL

  config.vm.box = "bento/ubuntu-22.04"
  config.vm.box_check_update = true

  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: IP_NW + "#{IP_START}"
    #master.vm.network "public_network" #bridge: "en1: Wi-Fi (AirPort)" 
    master.vm.provider "virtualbox" do |vb|
        vb.memory = 32768
        vb.cpus = 4
    end

    master.vm.provision "file", source: "~/.docker/config.json", destination: "/home/vagrant/.docker/config.json"
    master.vm.provision "shell" do |s|
      s.inline = "mkdir -p /var/lib/kubelet; cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json"
      s.privileged = true
    end

    master.vm.provision "shell", path: "scripts/common.sh"
    master.vm.provision "shell", path: "scripts/master.sh"
  end

  (1..NUM_WORKER_NODES).each do |i|

  config.vm.define "node0#{i}" do |node|
    node.vm.hostname = "worker-node0#{i}"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + i}"
    #node.vm.network "public_network"
    node.vm.provider "virtualbox" do |vb|
        vb.memory = 32768
        vb.cpus = 4
    end

    node.vm.provision "file", source: "~/.docker/config.json", destination: "/home/vagrant/.docker/config.json"
    node.vm.provision "shell" do |s|
      s.inline = "mkdir -p /var/lib/kubelet; cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json"
      s.privileged = true
    end

    node.vm.provision "file", source: "~/.docker/config.json", destination: "/var/lib/kubelet/config.json"
    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end

  end
end 