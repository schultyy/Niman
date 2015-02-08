module VagrantPlugins
  class RemoteShell
    def initialize(communication, machine)
      @channel = communication
      @machine = machine
      @platform = Niman::Platform.new(ruby_platform)
    end

    def os
      if @platform.linux?
        variant = @platform.linux_variant(-> (fn){ @machine.communicate.test("cat #{fn}")}, 
                                -> (fn){ @channel.execute("cat #{fn}") do |type, data|
                                           data.chomp
                                         end})
        variant[:family]
      else
        raise Niman::UnsupportedOSError
      end
    end

    def exec(command, use_sudo=false)
      @machine.ui.info(command, {color: :green})
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
          @machine.ui.info(data.chomp, options)
        end
      end
    end

    private

    def ruby_platform
      @channel.execute("ruby -e 'puts RUBY_PLATFORM'") do |type, data|
        return data.chomp
      end
    end
  end
end
