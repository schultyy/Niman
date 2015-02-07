module Niman
  class Shell
    def os
      output = `uname -a`
      if linux?
        linux_variant
      else
        raise Niman::UnsupportedOSError
      end
    end

    def exec(command)
      `#{command}`
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
        variant[:distro] = :debian if r[:distro].nil?
        variant[:family] = :debian if r[:variant].nil?
      elsif File.exists?('/etc/redhat-release') or File.exists?('/etc/centos-release')
        variant[:family] = :redhat if r[:family].nil?
        variant[:distro] = :centos if File.exists?('/etc/centos-release')
      elsif File.exists?('/etc/SuSE-release')
        variant[:distro] = :sles if r[:distro].nil?
      end
      variant
    end
  end
end
