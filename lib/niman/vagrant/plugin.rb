module VagrantPlugins
  class Plugin < Vagrant.plugin("2")
    name "niman"

    provisioner "niman" do
      require_relative 'provisioner'
      Provisioner
    end
  end
end
