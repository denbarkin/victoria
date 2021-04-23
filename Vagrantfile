# -*- mode: ruby -*-
# vi: set ft=ruby :
servers=[
  {
    :hostname => "controller",
    :box => "ubuntu/focal64",
    :ram => 12288,
    :cpu => 6,
    :disk => "20GB",
    :script => "sh /vagrant/controller_setup.sh"
  },
  {
    :hostname => "compute1",
    :box => "ubuntu/focal64",
    :ram => 6144,
    :cpu => 6,
    :disk => "10GB",
    :script => "sh /vagrant/compute1_setup.sh"
  },
  {
    :hostname => "block1",
    :box => "ubuntu/focal64",
    :ram => 2048,
    :cpu => 2,
    :disk => "10GB",
    :script => "sh /vagrant/block1_setup.sh"
  },
  {
    :hostname => "monitor1",
    :box => "ubuntu/focal64",
    :ram => 2048,
    :cpu => 2,
    :disk => "100GB",
    :script => "sh /vagrant/monitor1_setup.sh"
  },
  {
    :hostname => "deployment",
    :box => "ubuntu/focal64",
    :ram => 2048,
    :cpu => 2,
    :disk => "40GB",
    :script => "sh /vagrant/deployment_setup.sh"
  }
]

Vagrant.configure(2) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.disksize.size = machine[:disk]
            node.vm.hostname = machine[:hostname]
            node.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:ram], "--cpus", machine[:cpu]]
                vb.customize ["modifyvm", :id, "--nic2", "hostonly", "--hostonlyadapter2", "vboxnet1"]
                vb.customize ["modifyvm", :id, "--nic3", "natnetwork", "--nat-network3", "ProviderNetwork1", "--nicpromisc3", "allow-all"]
                if machine[:hostname] == "block1"
                    file_to_disk = File.realpath( "." ).to_s + "/block20cinder.vdi"
                    vb.customize ['createhd', '--filename', file_to_disk, '--format', 'VDI', '--size', "30720"]
                   # In line below: 'SCSI' may have to be changed to possibly other name of Storage Controller Name of VirtualBox VM
                    vb.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                end
              end
            node.vm.provision "shell", inline: machine[:script], privileged: true, run: "once"
            end
      end
end
