def target (vconfig)
  vconfig.vm.define :dvwa do | target |
    target.vm.box = "debian-squeeze-64"
    target.vm.box_url = "https://dl.dropboxusercontent.com/u/13054557/vagrant_boxes/debian-squeeze.box"

    target.berkshelf.enabled        = true

    target.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--name", "pentest-env-target-dvwa"]
    end

    #FIXME:
    target.vm.provision :shell, :inline => "sudo mkdir -p /var/chef/cache"

    target.vm.provision :chef_solo do | chef |
      chef.json = {
        "mysql" => {
          "server_root_password" => "dvwa",
          "server_debian_password" => "dvwa",
          "server_repl_password" => "dvwa"
        },
        "postgresql" => {
          "password" => {
            "postgres" => "postgres"
          }
        },
        "dvwa" => {
          "db" => {
            "use_psql" => false
          }
        }
      }
      chef.add_recipe("dvwa")
    end

    target.vm.network :private_network, ip: "192.168.107.101"
  end
end
