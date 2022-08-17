ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

# remove previous join.sh if it exists
# rm -f /vagrant/configs/join.sh


NUM_WORKER_NODES=2
IP_NW="10.0.0."
IP_START=10

Vagrant.configure("2") do |config|
  config.vm.provision "shell", env: {"IP_NW" => IP_NW, "IP_START" => IP_START}, inline: <<-SHELL
      apt-get update -y
      echo "$IP_NW$((IP_START)) master-node" >> /etc/hosts
      echo "$IP_NW$((IP_START+1)) worker-node01" >> /etc/hosts
      echo "$IP_NW$((IP_START+2)) worker-node02" >> /etc/hosts
  SHELL

  config.vm.box = "generic/ubuntu2204"
  config.vm.box_check_update = true

  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: IP_NW + "#{IP_START}"

    master.vm.synced_folder ".", "/vagrant", type: 'nfs', nfs_udp: false, nfs_version: 4
    master.vm.provider :libvirt do |vb|
      vb.driver = 'kvm'
      vb.memory = 32768
      vb.cpus = 16
      vb.cpu_mode = 'host-passthrough'
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
    node.vm.network "public_network", dev: "enp7s0"

    node.vm.synced_folder ".", "/vagrant", type: 'nfs', nfs_udp: false, nfs_version: 4
    node.vm.provider :libvirt do |vb|
      vb.memory = 32768
      vb.cpus = 16
      vb.cpu_mode = 'host-passthrough'
    end

    node.vm.provision "file", source: "~/.docker/config.json", destination: "/home/vagrant/.docker/config.json"
    node.vm.provision "shell" do |s|
      s.inline = "mkdir -p /var/lib/kubelet; cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json"
      s.privileged = true
    end

    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end

  # Setup GPU Nodes
  config.vm.define "gpu-node01" do |node|
    node.vm.hostname = "gpu-node01"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + NUM_WORKER_NODES + 1}"
    node.vm.network "public_network", dev: "enp7s0"

    node.vm.synced_folder ".", "/vagrant", type: 'nfs', nfs_udp: false, nfs_version: 4
    node.vm.provider :libvirt do |vb|
      vb.memory = 32768
      vb.cpus = 16
      vb.cpu_mode = 'host-passthrough'
      vb.pci :bus => '0x01', :slot => '0x00', :function => '0x0'
    end

    node.vm.provision "file", source: "~/.docker/config.json", destination: "/home/vagrant/.docker/config.json"
    node.vm.provision "shell" do |s|
      s.inline = "mkdir -p /var/lib/kubelet; cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json"
      s.privileged = true
    end

    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end

  config.vm.define "gpu-node02" do |node|
    node.vm.hostname = "gpu-node02"
    node.vm.network "private_network", ip: IP_NW + "#{IP_START + NUM_WORKER_NODES + 2}"
    node.vm.network "public_network", dev: "enp7s0"

    node.vm.synced_folder ".", "/vagrant", type: 'nfs', nfs_udp: false, nfs_version: 4
    node.vm.provider :libvirt do |vb|
      vb.memory = 32768
      vb.cpus = 16
      vb.cpu_mode = 'host-passthrough'
      vb.pci :bus => '0x02', :slot => '0x00', :function => '0x0'
    end

    node.vm.provision "file", source: "~/.docker/config.json", destination: "/home/vagrant/.docker/config.json"
    node.vm.provision "shell" do |s|
      s.inline = "mkdir -p /var/lib/kubelet; cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json"
      s.privileged = true
    end

    node.vm.provision "shell", path: "scripts/common.sh"
    node.vm.provision "shell", path: "scripts/node.sh"
  end


  end
end 