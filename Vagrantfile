# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
  end

  (1..3 ).each do |i|
    config.vm.define "nomad-a-#{i}" do |n|
      n.vm.provision "ansible" do |ansible|
        ansible.playbook ="ansible/playbooks/nomad-node.yml"
      end
  
      if i == 1
        # Expose the nomad ports  
        n.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
        n.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true
        n.vm.network "forwarded_port", guest: 9411, host: 9411, auto_correct: true
       # n.vm.provision "shell", path: "node-install-a-1.sh"
      end

      n.vm.hostname = "nomad-a-#{i}"
      n.vm.network "private_network", ip: "172.16.1.#{i+100}"
    end
  end

  config.vm.define "api-gateway" do |n|
      n.vm.provision "ansible" do |ansible|
        ansible.playbook ="ansible/playbooks/api-gateway.yml"
      end

      n.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

      n.vm.hostname = "api-gateway"
      n.vm.network "private_network", ip: "172.16.1.145"
  end

end