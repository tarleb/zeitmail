# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/jessie64"

  ## Disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
  ## Salt states and pillar
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.synced_folder "salt/pillar/", "/srv/pillar/"

  ### Mail Server VM
  ### ==============
  config.vm.define "mail", primary: true do |mail|
    mail.vm.network "private_network", ip: "192.168.23.2"
    mail.vm.hostname = "mail.test"

    ## Mail files (mbox)
    mail.vm.synced_folder "tests/mail-mnt/", "/home/vagrant/mail",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=770,fmode=660"]

    ## Mail forward
    mail.vm.provision :shell,
      inline: "echo /home/vagrant/mail/test.mbox > /home/vagrant/.forward"

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
    staging.vm.hostname = "staging.test"
    # This is used for testing with salt-ssh, so no mounting of salt folders
    staging.vm.synced_folder "salt/roots/", "/srv/salt/", disabled: true
    staging.vm.synced_folder "salt/pillar/", "/srv/pillar/", disabled: true
  end

  ### Test VM
  ### =======
  config.vm.define "testing" do |testing|
    testing.vm.network "private_network", ip: "192.168.42.2"
    testing.vm.hostname = "testing.test"

    # Tests
    testing.vm.synced_folder "tests/", "/home/vagrant/tests",
      owner: "vagrant",
      group: "vagrant",
      mount_options: ["dmode=770,fmode=660"]

    # Let the machine know where the test mail server is.
    testing.vm.provision :shell, inline: "echo 192.168.23.2 mail.test >> /etc/hosts"

    # Provision with Salt
    testing.vm.provision :salt do |salt|
      salt.minion_config = "salt/testing.minion"
      salt.run_highstate = true
    end
  end
end
