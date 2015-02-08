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
        `sudo #{command}`
      else
        `#{command}`
      end
    end
  end
end
