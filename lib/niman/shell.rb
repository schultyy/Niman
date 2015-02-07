module Niman
  class Shell
    def os
      if linux?
        linux_variant[:family]
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

    private

    def windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def unix?
      !windows?
    end

    def linux?
      unix? && !mac?
    end

    def linux_variant
      variant = { :distro => nil, :family => nil }

      if File.exists?('/etc/lsb-release')
        File.open('/etc/lsb-release', 'r').read.each_line do |line|
          variant = { :distro => $1 } if line =~ /^DISTRIB_ID=(.*)/
        end
      end

      if File.exists?('/etc/debian_version')
        variant[:distro] = :debian if variant[:distro].nil?
        variant[:family] = :debian if variant[:variant].nil?
      elsif File.exists?('/etc/redhat-release') or File.exists?('/etc/centos-release')
        variant[:family] = :redhat if variant[:family].nil?
        variant[:distro] = :centos if File.exists?('/etc/centos-release')
      elsif File.exists?('/etc/SuSE-release')
        variant[:distro] = :sles if variant[:distro].nil?
      end
      variant
    end
  end
end
