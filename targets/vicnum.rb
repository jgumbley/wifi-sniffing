def target (vconfig)
  vconfig.vm.define :vicnum do | target |
    target.vm.box = "debian-squeeze-64"
    target.vm.box_url = "https://dl.dropboxusercontent.com/u/13054557/vagrant_boxes/debian-squeeze.box"

    target.berkshelf.enabled        = true

    target.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--name", "pentest-env-target-vicnum"]
    end

    #FIXME:
    target.vm.provision :shell, :inline => "sudo mkdir -p /var/chef/cache"

    target.vm.provision :chef_solo do | chef |
      chef.json = {
        "mysql" => {
          "server_root_password" => "vicnum",
          "server_debian_password" => "vicnum",
          "server_repl_password" => "vicnum"
        },
        "vicnum" => {
          "version" => "vicnum15"
        }
      }
      chef.add_recipe("vicnum")
    end

    target.vm.network :private_network, ip: "192.168.107.102"
  end
end
