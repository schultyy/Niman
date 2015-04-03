require 'niman/platform'

module Niman
  class Shell
    def initialize
      @platform = Niman::Platform.new(RUBY_PLATFORM)
    end

    def os
      if @platform.linux?
        variant = @platform.linux_variant(-> (fn){ File.exists?(fn)},
                                -> (fn){ File.read(fn)})
        variant[:family]
      else
        raise Niman::UnsupportedOSError
      end
    end

    def exec(command, use_sudo=false)
      if use_sudo
        system("sudo #{command}")
      else
        system("#{command}")
      end
    end

    def print(message, type)
      case type
      when :error
        STDERR.puts message
      else
        STDOUT.puts message
      end
    end

    def create_file(path, content)
      File.open(File.expand_path(path), 'w') do |handle|
        handle.write(content)
      end
    end
  end
end
