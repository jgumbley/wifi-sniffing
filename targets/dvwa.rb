def target (vconfig)
  vconfig.vm.define :dvwa do | target |
    target.vm.box = "debian-squeeze-64"
    target.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-607-x64-vbox4210.box"

    target.berkshelf.enabled = true

    target.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--name", "pentest-env-target-dvwa"]
    end

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
