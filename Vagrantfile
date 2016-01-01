# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.network "private_network", ip: "192.168.23.2"
  config.vm.hostname = "zeitmail.local"

  ## Disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  ## Salt states
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  ## Mail files (mbox)
  config.vm.synced_folder "tests/mail-mnt/", "/home/vagrant/mail",
    owner: "vagrant",
    group: "vagrant",
    mount_options: ["dmode=770,fmode=660"]
  ## Mail forward
  config.vm.provision :shell,
    inline: "echo /home/vagrant/mail/test.mbox > /home/vagrant/.forward"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end
end
