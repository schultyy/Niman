module VagrantPlugins
  class RemoteShell
    def initialize(communication, user_interface)
      @channel = communication
      @user_interface = user_interface
    end

    def os
      :debian
    end

    def exec(command, use_sudo=false)
      @user_interface.info(command, {color: :green})
      opts = { error_check: false, elevated: true }
      @channel.sudo(command, opts) do |type, data|
        if [:stderr, :stdout].include?(type)
          #Output the data with the proper color based on the stream.
          color = type == :stdout ? :green : :red
          # Clear out the newline since we add one
          data = data.chomp
          next if data.empty?
          options = {}
          options[:color] = :green
          @user_interface.info(data.chomp, options)
        end
      end
    end
  end
end
