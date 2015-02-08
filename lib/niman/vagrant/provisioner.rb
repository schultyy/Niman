require "vagrant/util/retryable"
module VagrantPlugins
  class Provisioner < Vagrant.plugin("2", :provisioner)
    include Vagrant::Util::Retryable
    def configure(root_config)
    end

    def provision
      @machine.communicate.tap do |comm|
        info = nil
        retryable(on: Vagrant::Errors::SSHNotReady, tries: 3, sleep: 2) do
          info = @machine.ssh_info
          raise Vagrant::Errors::SSHNotReady if info.nil?
        end
        user = info[:username]
        # Execute it with sudo
        comm.execute(
          "uname -a",
          sudo: config.privileged,
          error_key: :ssh_bad_exit_status_muted
        ) do |type, data|
          handle_comm(type, data)
        end
      end

      #require 'niman'
      #app = Niman::CLI::Application.new
      #app.apply
    end

    def handle_comm(type, data)
      if [:stderr, :stdout].include?(type)
        #Output the data with the proper color based on the stream.
        color = type == :stdout ? :green : :red
        # Clear out the newline since we add one
        data = data.chomp
        return if data.empty?
        options = {}
        options[:color] = color if !config.keep_color
        @machine.ui.info(data.chomp, options)
      end
    end
  end
end
