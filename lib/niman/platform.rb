module Niman
  class Platform
    def initialize(platform)
      @platform = platform
    end

    def windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ @platform) != nil
    end

    def mac?
      (/darwin/ =~ @platform) != nil
    end

    def unix?
      !windows?
    end

    def linux?
      unix? && !mac?
    end

    def linux_variant(exists_block, read_block)
      variant = { :distro => nil, :family => nil }

      if exists_block.('/etc/lsb-release')
        lsb_release = read_block.('/etc/lsb-release') 
        variant = { :distro => $1 } if lsb_release =~ /^DISTRIB_ID=(.*)/
      end

      if exists_block.('/etc/debian_version')
        variant[:distro] = :debian if variant[:distro].nil?
        variant[:family] = :debian if variant[:variant].nil?
      elsif exists_block.('/etc/redhat-release') or exists_block.('/etc/centos-release')
        variant[:family] = :redhat if variant[:family].nil?
        variant[:distro] = :centos if exists_block.('/etc/centos-release')
      elsif exists_block.('/etc/SuSE-release')
        variant[:distro] = :sles if variant[:distro].nil?
      end
      variant
    end
  end
end
