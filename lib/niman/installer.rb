require 'virtus'
require 'niman/exceptions'

module Niman
  class Installer
    include Virtus.model

    attribute :managers, Hash[Symbol=>String], default: Hash.new
    attribute :shell, Object

    def install(packages)
      package_manager = managers.fetch(shell.os.to_sym) { raise Niman::InstallError, shell.os }
      Array(packages).each do |package|
        if package.respond_to?(:package_names)
          package_name = package.package_names[shell.os.to_sym]
          shell.exec("#{package_manager} install #{package_name}", true)
        elsif package.respond_to?(:name)
          shell.exec("#{package_manager} install #{package.name}", true)
        end
      end
    end
  end
end
