require 'virtus'
require 'niman/exceptions'
require 'niman/package_resolver'

module Niman
  class Installer
    include Virtus.model

    attribute :managers, Hash[Symbol=>String], default: Hash.new
    attribute :shell, Object

    def install(packages)
      Array(packages).each do |package|
        self.install_package(package)
      end
    end

    def install_package(package)
      package_manager = managers.fetch(shell.os.to_sym) { raise Niman::InstallError, shell.os }
      if package.respond_to?(:package_names)
        package_name = package.package_names.fetch(shell.os.to_sym) { raise Niman::InstallError, "Package has no support for #{shell.os}" }
        shell.exec("#{package_manager} install #{package_name}", true)
      elsif package.respond_to?(:name)
        shell.exec("#{package_manager} install #{package.name}", true)
      end
    end
  end
end
