# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/focal64" # 16.04 LTS
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
  end

  # 4-node configuration - Region A
  (1..4).each do |i|
    config.vm.define "nomad-a-#{i}" do |n|
      n.vm.provision "shell", path: "node-install-a.sh"
      if i == 1
        # Expose the nomad ports  
        n.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
        n.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true
      end
      n.vm.hostname = "nomad-a-#{i}"
      n.vm.network "private_network", ip: "172.16.1.#{i+100}"
    end
  end

end