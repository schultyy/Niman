require 'virtus'
require 'niman/exceptions'
require 'niman/package_resolver'
require 'niman/package_manager'

module Niman
  class Installer
    include Virtus.model

    attribute :package_manager, Niman::PackageManager

    def install(packages)
      Array(packages).each do |package|
        self.install_package(package)
      end
    end

    def install_package(package)
      return unless package.installable?
      shell = package_manager.shell
      if package.respond_to?(:package_names)
        package_name = package.package_names.fetch(shell.os.to_sym) { raise Niman::InstallError, "Package has no support for #{shell.os}" }
        package_manager.install(package_name)
      elsif package.respond_to?(:name)
        package_manager.install(package.name)
      end
    end
  end
end
