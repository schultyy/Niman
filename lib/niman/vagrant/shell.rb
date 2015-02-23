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
                                          -> (fn){ @channel.execute("cat #{fn}") { |type, data| data.chomp}})
        variant[:family]
      else
        raise Niman::UnsupportedOSError
      end
    end

    def exec(command, use_sudo=false)
      @machine.ui.info(command, {color: :green})
      opts = { error_check: false, elevated: use_sudo }
      handler = Proc.new do |type, data|
        if [:stderr, :stdout].include?(type)
          color = type == :stdout ? :green : :red
          data = data.chomp
          next if data.empty?
          options = {}
          options[:color] = :green
          @machine.ui.info(data.chomp, options)
        end
      end
      if use_sudo
        @channel.sudo(command, opts, &handler)
      else
        @channel.execute(command, opts, &handler)
      end
    end

    def print(message, type)
      case type
      when :error
        @machine.ui.error(message, {:color => :red})
      else
        @machine.ui.info(message, {:color => :green})
      end
    end

    def create_file(path, content)
      if content.include?("\n")
        cmd = "cat > #{path} << EOL\n#{content}\nEOL"
      else
        cmd  = "echo #{content} > #{path}"
      end
      self.exec(cmd, true)
    end

    private

    def ruby_platform
      @channel.execute("ruby -e 'puts RUBY_PLATFORM'") do |type, data|
        return data.chomp
      end
    end
  end
end
