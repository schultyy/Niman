require "vagrant/util/retryable"
require 'niman/vagrant/shell'

module VagrantPlugins
  class Provisioner < Vagrant.plugin("2", :provisioner)
    include Vagrant::Util::Retryable
    def configure(root_config)
    end

    def provision
      require 'niman'
      @machine.communicate.tap do |comm|
        vagrant_shell = VagrantPlugins::RemoteShell.new(comm, @machine)
        app = Niman::CLI::Application.new
        app.client_shell  = vagrant_shell
        app.silent = true
        app.apply
      end
    end

    def cleanup
    end
  end
end
