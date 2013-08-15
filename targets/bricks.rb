def target (vconfig)
  vconfig.vm.define :bricks do | target |
    target.vm.box = "debian-squeeze-64"
    target.vm.box_url = "https://dl.dropboxusercontent.com/u/13054557/vagrant_boxes/debian-squeeze.box"

    target.berkshelf.enabled        = true

    target.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--name", "pentest-env-target-bricks"]
    end

    #FIXME:
    target.vm.provision :shell, :inline => "sudo mkdir -p /var/chef/cache"

    target.vm.provision :chef_solo do | chef |
      chef.json = {
        "mysql" => {
          "server_root_password" => "bricks",
          "server_debian_password" => "bricks",
          "server_repl_password" => "bricks"
        },
        "bricks" => {
          "codename" => "raidak"
        }
      }
      chef.add_recipe("bricks")
    end

    target.vm.network :private_network, ip: "192.168.107.104"
  end
end
