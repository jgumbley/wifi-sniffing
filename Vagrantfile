require 'rbconfig'
require File.expand_path('lib/pentestenv/target')

# Targets list to deploy
targets = [  ]

Vagrant::configure('2') do | config |

  config.ssh.forward_agent = true

  config.vm.define :kali do | kali |

    kali.ssh.private_key_path = "ssh-keys/kali-1.0"
    kali.ssh.username = "root"

    kali.vm.box = "kali-1.0.4-amd64"
    kali.vm.box_url = "http://ftp.sliim-projects.eu/boxes/kali-linux-1.0.4-amd64.box"

    kali.vm.network :public_network
    kali.vm.network :private_network, ip: "192.168.107.145"

    kali.vm.provider "virtualbox" do |v|
      v.gui = true
      v.customize ["modifyvm", :id, "--name", "pentest-env-kali-1.0"]
      v.customize ["modifyvm", :id, "--memory", 1024]
      v.customize ["modifyvm", :id, "--macaddress3", "0800276cf835"]
    end

    if File.exists?(ENV["HOME"] + "/repositories")
      kali.vm.synced_folder ENV["HOME"] + "/repositories", "/root/repositories"
    end
  end

  # Target(s) deployment
  targets.each do | t |
    target = Pentestenv::Target.new(config, t)
    target.deploy
  end

end
