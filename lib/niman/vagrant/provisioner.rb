module VagrantPlugins
  class Provisioner < Vagrant.plugin("2", :provisioner)
    def configure(root_config)
      puts "CONFIGURE"
    end

    def provision
      puts "PROVISION"
      require 'niman'
      app = Niman::CLI::Application.new
      app.apply
    end
  end
end
