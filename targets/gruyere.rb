def target (vconfig)
  vconfig.vm.define :gruyere do | target |
    target.vm.box = "debian-squeeze-64"
    target.vm.box_url = "https://dl.dropboxusercontent.com/u/13054557/vagrant_boxes/debian-squeeze.box"

    target.berkshelf.enabled        = true

    target.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--name", "pentest-env-target-gruyere"]
    end

    #FIXME:
    target.vm.provision :shell, :inline => "sudo mkdir -p /var/chef/cache"

    target.vm.provision :chef_solo do | chef |
      chef.add_recipe("gruyere::apache2_proxy")
    end

    target.vm.network :private_network, ip: "192.168.107.103"
  end
end
