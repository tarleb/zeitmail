# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"

  ## Disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  ### Mail Server VM
  ### ==============
  config.vm.define "mail", primary: true do |mail|
    mail.vm.network "private_network", ip: "192.168.23.2"
    mail.vm.hostname = "mail.zeitmail.test"

    ## Mail forward
    mail.vm.provision :shell,
      inline: "echo \\\\vagrant,/home/vagrant/mail/test.mbox > /home/vagrant/.forward"

    ## Salt states and pillar
    config.vm.synced_folder "salt/roots/", "/srv/salt/"
    config.vm.synced_folder "salt/pillar/", "/srv/pillar/"

    # Provision with Salt
    mail.vm.provision :salt do |salt|
      salt.minion_config = "salt/mail.minion"
      salt.run_highstate = true
    end
  end

  ### Staging VM
  ### ==========
  config.vm.define "staging" do |staging|
    staging.vm.network "private_network", ip: "192.168.23.128"
    staging.vm.hostname = "staging.zeitmail.test"
  end
end
