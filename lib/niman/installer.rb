require 'virtus'
require 'niman/exceptions'

module Niman
  class Installer
    include Virtus.model

    attribute :managers, Hash[Symbol=>String], default: Hash.new
    attribute :shell, Object

    def install(packages)
      package_manager = managers.fetch(shell.os) { raise Niman::InstallError }
      Array(packages).each do |package|
        shell.exec("#{package_manager} install #{package.name}")
      end
    end
  end
end
